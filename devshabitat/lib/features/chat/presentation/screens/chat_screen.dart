import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:devshabitat/core/theme/devhabitat_theme.dart';
import 'package:devshabitat/core/theme/devhabitat_colors.dart';
import '../blocs/chat_bloc.dart';
import '../widgets/message_bubble.dart';
import '../../domain/entities/message.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String participantName;

  const ChatScreen({
    Key? key,
    required this.conversationId,
    required this.participantName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<Map<String, String>> _mockUsers = [
    {
      'id': '1',
      'name': 'Ahmet Yılmaz',
      'email': 'ahmet@example.com',
    },
    {
      'id': '2',
      'name': 'Ayşe Demir',
      'email': 'ayse@example.com',
    },
    {
      'id': '3',
      'name': 'Mehmet Kaya',
      'email': 'mehmet@example.com',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: widget.conversationId,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        content: image.path,
        type: MessageType.image,
        timestamp: DateTime.now(),
        readBy: {FirebaseAuth.instance.currentUser!.uid: DateTime.now()},
      );

      context.read<ChatBloc>().add(SendMessage(message));
      _scrollToBottom();
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result != null) {
      final file = result.files.first;
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: widget.conversationId,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        content: file.path!,
        type: MessageType.file,
        timestamp: DateTime.now(),
        readBy: {FirebaseAuth.instance.currentUser!.uid: DateTime.now()},
      );

      context.read<ChatBloc>().add(SendMessage(message));
      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: widget.conversationId,
      senderId: FirebaseAuth.instance.currentUser!.uid,
      content: _messageController.text.trim(),
      type: MessageType.text,
      timestamp: DateTime.now(),
      readBy: {FirebaseAuth.instance.currentUser!.uid: DateTime.now()},
    );

    context.read<ChatBloc>().add(SendMessage(message));
    _messageController.clear();
    _scrollToBottom();
  }

  void _showNewConversationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: DevHabitatColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yeni Sohbet',
              style: DevHabitatTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              style: DevHabitatTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Kullanıcı ara...',
                hintStyle: DevHabitatTheme.bodyMedium.copyWith(
                  color: DevHabitatColors.textTertiary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: DevHabitatColors.textSecondary,
                ),
                filled: true,
                fillColor: DevHabitatColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _mockUsers.length,
                itemBuilder: (context, index) {
                  final user = _mockUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: DevHabitatColors.primaryBlue,
                      child: Text(
                        user['name']![0].toUpperCase(),
                        style: DevHabitatTheme.labelMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      user['name']!,
                      style: DevHabitatTheme.titleMedium,
                    ),
                    subtitle: Text(
                      user['email']!,
                      style: DevHabitatTheme.bodySmall.copyWith(
                        color: DevHabitatColors.textSecondary,
                      ),
                    ),
                    onTap: () {
                      context.pop();
                      context.push('/chat/${user['id']}', extra: {
                        'participantName': user['name'],
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        context.read(),
      )..add(LoadMessages(widget.conversationId)),
      child: Scaffold(
        backgroundColor: DevHabitatColors.darkBackground,
        appBar: AppBar(
          backgroundColor: DevHabitatColors.darkSurface,
          title: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: DevHabitatColors.primaryBlue,
                child: Text(
                  widget.participantName[0].toUpperCase(),
                  style: DevHabitatTheme.labelMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.participantName,
                    style: DevHabitatTheme.titleMedium,
                  ),
                  Text(
                    'Çevrimiçi',
                    style: DevHabitatTheme.labelSmall.copyWith(
                      color: DevHabitatColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.video_call),
              onPressed: () {
                // TODO: Video görüşmesi başlatma işlemi
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Video görüşmesi özelliği yakında eklenecek'),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: DevHabitatColors.darkSurface,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.block),
                        title: const Text('Kullanıcıyı Engelle'),
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Kullanıcı engelleme işlemi
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Sohbeti Sil'),
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Sohbet silme işlemi
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _MessagesList(
                scrollController: _scrollController,
              ),
            ),
            _MessageInput(
              controller: _messageController,
              onSend: _sendMessage,
              onImagePick: _pickImage,
              onFilePick: _pickFile,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  final ScrollController scrollController;

  const _MessagesList({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ChatError) {
          return Center(
            child: Text(
              state.message,
              style: DevHabitatTheme.bodyMedium.copyWith(
                color: DevHabitatColors.error,
              ),
            ),
          );
        }

        if (state is ChatLoaded) {
          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages[index];
              final isOwnMessage =
                  message.senderId == FirebaseAuth.instance.currentUser?.uid;

              return MessageBubble(
                message: message,
                isOwnMessage: isOwnMessage,
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onImagePick;
  final VoidCallback onFilePick;

  const _MessageInput({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onImagePick,
    required this.onFilePick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {
              // TODO: Emoji seçici eklenecek
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emoji seçici yakında eklenecek'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.gif),
            onPressed: () {
              // TODO: GIF seçici eklenecek
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('GIF seçici yakında eklenecek'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: onImagePick,
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: onFilePick,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: DevHabitatTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Mesaj yazın...',
                hintStyle: DevHabitatTheme.bodyMedium.copyWith(
                  color: DevHabitatColors.textTertiary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: DevHabitatColors.darkCard,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
