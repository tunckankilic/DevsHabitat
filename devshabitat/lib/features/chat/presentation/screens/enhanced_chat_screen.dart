import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import '../blocs/chat_bloc.dart';
import '../blocs/typing_indicator_bloc.dart';
import '../widgets/enhanced_message_bubble.dart';
import '../widgets/file_upload_widget.dart';
import '../widgets/message_search_widget.dart';
import '../../data/services/file_upload_service.dart';
import '../../data/services/encryption_service.dart' hide Message, MessageType;
import '../../data/services/message_search_service.dart' hide MessageType;
import '../../domain/entities/message.dart';

class EnhancedChatScreen extends StatefulWidget {
  final String conversationId;
  final String participantName;
  final String participantId;

  const EnhancedChatScreen({
    Key? key,
    required this.conversationId,
    required this.participantName,
    required this.participantId,
  }) : super(key: key);

  @override
  State<EnhancedChatScreen> createState() => _EnhancedChatScreenState();
}

class _EnhancedChatScreenState extends State<EnhancedChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  late final AnimationController _typingAnimationController;
  late final FileUploadService _fileUploadService;
  late final EncryptionService _encryptionService;
  late final MessageSearchService _searchService;

  bool _isSearchMode = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fileUploadService = FileUploadService();
    _encryptionService = EncryptionService();
    _searchService = MessageSearchService();

    _initializeEncryption();
    _setupTypingIndicator();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeEncryption() async {
    try {
      await _encryptionService.initialize();
    } catch (e) {
      _showErrorSnackBar('Encryption initialization failed: $e');
    }
  }

  void _setupTypingIndicator() {
    _messageController.addListener(() {
      final text = _messageController.text;
      context.read<TypingIndicatorBloc>().add(
            TypingStatusChanged(
              conversationId: widget.conversationId,
              isTyping: text.isNotEmpty,
            ),
          );
    });
  }

  void _loadMessages() {
    context.read<ChatBloc>().add(LoadMessages(widget.conversationId));
  }

  // ==================== MESSAGE SENDING ====================

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    try {
      // Create message
      final message = Message(
        id: _encryptionService.generateMessageId(),
        conversationId: widget.conversationId,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        content: text,
        type: MessageType.text,
        timestamp: DateTime.now(),
        readBy: {FirebaseAuth.instance.currentUser!.uid: DateTime.now()},
      );

      // Encrypt message
      final encryptedMessage = await message.encrypt(_encryptionService);

      // Send message
      context.read<ChatBloc>().add(SendMessage(encryptedMessage));

      // Clear input and scroll
      _messageController.clear();
      _scrollToBottom();

      // Stop typing indicator
      context.read<TypingIndicatorBloc>().add(
            TypingStatusChanged(
              conversationId: widget.conversationId,
              isTyping: false,
            ),
          );
    } catch (e) {
      _showErrorSnackBar('Failed to send message: $e');
    }
  }

  // ==================== FILE UPLOAD ====================

  Future<void> _pickAndUploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        await _uploadFile(result.files.single.path!);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick file: $e');
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        await _uploadFile(image.path);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _uploadFile(String filePath) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final messageId = _encryptionService.generateMessageId();

      // Upload file with progress tracking
      final uploadResult = await _fileUploadService.uploadFile(
        filePath: filePath,
        conversationId: widget.conversationId,
        messageId: messageId,
        userId: currentUser.uid,
        onProgress: (progress) {
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      // Create file message
      final fileMessage = Message(
        id: messageId,
        conversationId: widget.conversationId,
        senderId: currentUser.uid,
        content: uploadResult.fileName,
        type: _getMessageTypeFromExtension(uploadResult.extension),
        timestamp: DateTime.now(),
        readBy: {currentUser.uid: DateTime.now()},
        attachments: [
          MessageAttachment(
            url: uploadResult.downloadUrl,
            fileName: uploadResult.fileName,
            fileSize: uploadResult.fileSize,
            mimeType: uploadResult.mimeType,
          ),
        ],
      );

      // Encrypt and send
      final encryptedMessage = await fileMessage.encrypt(_encryptionService);
      context.read<ChatBloc>().add(SendMessage(encryptedMessage));

      _scrollToBottom();
    } catch (e) {
      _showErrorSnackBar('File upload failed: $e');
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  MessageType _getMessageTypeFromExtension(String extension) {
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    if (imageExtensions.contains(extension.toLowerCase())) {
      return MessageType.image;
    }
    return MessageType.file;
  }

  // ==================== SEARCH FUNCTIONALITY ====================

  void _toggleSearchMode() {
    setState(() {
      _isSearchMode = !_isSearchMode;
    });

    if (!_isSearchMode) {
      // Exit search mode - reload all messages
      _loadMessages();
    }
  }

  Future<void> _searchMessages(String query) async {
    if (query.trim().isEmpty) {
      _loadMessages();
      return;
    }

    try {
      final searchResults = await _searchService.searchMessages(
        conversationId: widget.conversationId,
        query: query,
      );

      // Convert search results to messages and display
      final messages = searchResults
          .map((result) => Message(
                id: result.messageId,
                conversationId: widget.conversationId,
                senderId: result.senderId,
                content: result.content,
                type: MessageType.values.firstWhere(
                  (type) => type.name == result.messageType.name,
                  orElse: () => MessageType.text,
                ),
                timestamp: result.timestamp,
                readBy: {},
              ))
          .toList();

      context.read<ChatBloc>().add(MessagesUpdated(messages));
    } catch (e) {
      _showErrorSnackBar('Search failed: $e');
    }
  }

  // ==================== UI HELPERS ====================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==================== BUILD METHODS ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DevHabitatColors.darkBackground,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (_isSearchMode) _buildSearchBar(),
          if (_isUploading) _buildUploadProgress(),
          Expanded(child: _buildMessagesList()),
          _buildTypingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: DevHabitatColors.darkSurface,
      title: _buildAppBarTitle(),
      actions: [
        IconButton(
          icon: Icon(_isSearchMode ? Icons.close : Icons.search),
          onPressed: _toggleSearchMode,
        ),
        IconButton(
          icon: const Icon(Icons.video_call),
          onPressed: _startVideoCall,
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view_profile',
              child: Text('View Profile'),
            ),
            const PopupMenuItem(
              value: 'media_gallery',
              child: Text('Media Gallery'),
            ),
            const PopupMenuItem(
              value: 'encryption_info',
              child: Text('Encryption Info'),
            ),
            const PopupMenuItem(
              value: 'block_user',
              child: Text('Block User'),
            ),
          ],
          onSelected: _handleMenuAction,
        ),
      ],
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: DevHabitatColors.primaryBlue,
          child: Text(
            widget.participantName[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.participantName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              BlocBuilder<TypingIndicatorBloc, TypingIndicatorState>(
                builder: (context, state) {
                  if (state is UserTyping &&
                      state.userId == widget.participantId) {
                    return const Text(
                      'typing...',
                      style: TextStyle(
                        fontSize: 12,
                        color: DevHabitatColors.primaryBlue,
                      ),
                    );
                  }
                  return const Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: DevHabitatColors.success,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: DevHabitatColors.darkSurface,
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search messages...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: DevHabitatColors.darkCard,
        ),
        onChanged: _searchMessages,
      ),
    );
  }

  Widget _buildUploadProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: DevHabitatColors.darkSurface,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.upload_file,
                  color: DevHabitatColors.primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Uploading... ${(_uploadProgress * 100).toInt()}%',
                  style: const TextStyle(color: DevHabitatColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _uploadProgress,
            backgroundColor: DevHabitatColors.darkCard,
            valueColor: const AlwaysStoppedAnimation<Color>(
              DevHabitatColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ChatError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: DevHabitatColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load messages',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: DevHabitatColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadMessages,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ChatLoaded) {
          if (state.messages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: DevHabitatColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: DevHabitatColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start the conversation!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: DevHabitatColors.textTertiary,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages[index];
              final isOwnMessage =
                  message.senderId == FirebaseAuth.instance.currentUser?.uid;

              return FutureBuilder<Message>(
                future: message.decrypt(_encryptionService),
                builder: (context, snapshot) {
                  final displayMessage = snapshot.data ?? message;

                  return EnhancedMessageBubble(
                    message: displayMessage,
                    isOwnMessage: isOwnMessage,
                    onReply: () => _replyToMessage(displayMessage),
                    onReact: (emoji) => _reactToMessage(displayMessage, emoji),
                  );
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTypingIndicator() {
    return BlocBuilder<TypingIndicatorBloc, TypingIndicatorState>(
      builder: (context, state) {
        if (state is UserTyping && state.userId == widget.participantId) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: DevHabitatColors.primaryBlue,
                  child: Text(
                    widget.participantName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                _buildTypingAnimation(),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTypingAnimation() {
    return AnimatedBuilder(
      animation: _typingAnimationController,
      builder: (context, child) {
        return Row(
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animation = Tween<double>(begin: 0.4, end: 1.0).animate(
              CurvedAnimation(
                parent: _typingAnimationController,
                curve: Interval(delay, 0.8 + delay, curve: Curves.easeInOut),
              ),
            );

            return Container(
              margin: const EdgeInsets.only(right: 4),
              child: Opacity(
                opacity: animation.value,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: DevHabitatColors.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DevHabitatColors.darkSurface,
        border: Border(
          top: BorderSide(
            color: DevHabitatColors.darkBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _pickAndUploadFile,
            color: DevHabitatColors.textSecondary,
          ),
          IconButton(
            icon: const Icon(Icons.photo_camera),
            onPressed: _pickAndUploadImage,
            color: DevHabitatColors.textSecondary,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: DevHabitatColors.darkCard,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _messageController,
              builder: (context, value, child) {
                return IconButton(
                  icon: Icon(
                    value.text.trim().isNotEmpty ? Icons.send : Icons.mic,
                  ),
                  onPressed: value.text.trim().isNotEmpty
                      ? _sendMessage
                      : _startVoiceRecording,
                  color: DevHabitatColors.primaryBlue,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================== ACTION HANDLERS ====================

  void _replyToMessage(Message message) {
    // TODO: Implement reply functionality
    _messageFocusNode.requestFocus();
  }

  void _reactToMessage(Message message, String emoji) {
    // TODO: Implement message reactions
  }

  void _startVideoCall() {
    // TODO: Implement video call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video call feature coming soon')),
    );
  }

  void _startVoiceRecording() {
    // TODO: Implement voice recording
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice message feature coming soon')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'view_profile':
        // TODO: Navigate to profile
        break;
      case 'media_gallery':
        // TODO: Show media gallery
        break;
      case 'encryption_info':
        _showEncryptionInfo();
        break;
      case 'block_user':
        _showBlockUserDialog();
        break;
    }
  }

  void _showEncryptionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End-to-End Encryption'),
        content: const Text(
          'Your messages are secured with end-to-end encryption. '
          'Only you and the recipient can read them.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBlockUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text(
          'Are you sure you want to block ${widget.participantName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement block user
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }
}
