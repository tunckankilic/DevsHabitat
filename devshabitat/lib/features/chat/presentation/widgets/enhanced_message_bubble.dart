import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/message.dart';

class EnhancedMessageBubble extends StatelessWidget {
  final Message message;
  final bool isOwnMessage;
  final VoidCallback onReply;
  final Function(String) onReact;

  const EnhancedMessageBubble({
    Key? key,
    required this.message,
    required this.isOwnMessage,
    required this.onReply,
    required this.onReact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOwnMessage) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isOwnMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                _buildMessageContent(),
                const SizedBox(height: 4),
                _buildMessageFooter(),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isOwnMessage) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isOwnMessage
          ? DevHabitatColors.primaryBlue
          : DevHabitatColors.darkCard,
      child: Text(
        message.senderId[0].toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOwnMessage
            ? DevHabitatColors.primaryBlue
            : DevHabitatColors.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _buildMessageTypeContent(),
    );
  }

  Widget _buildMessageTypeContent() {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            color: isOwnMessage ? Colors.white : DevHabitatColors.textPrimary,
          ),
        );
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            message.attachments?.first.url ?? '',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 200,
                height: 200,
                color: DevHabitatColors.darkSurface,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 200,
                height: 200,
                color: DevHabitatColors.darkSurface,
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: DevHabitatColors.error,
                  ),
                ),
              );
            },
          ),
        );
      case MessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.insert_drive_file,
              color: DevHabitatColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.attachments?.first.fileName ?? 'File',
                    style: TextStyle(
                      color: isOwnMessage
                          ? Colors.white
                          : DevHabitatColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _formatFileSize(message.attachments?.first.fileSize ?? 0),
                    style: TextStyle(
                      fontSize: 12,
                      color: isOwnMessage
                          ? Colors.white.withOpacity(0.7)
                          : DevHabitatColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMessageFooter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.timestamp),
          style: TextStyle(
            fontSize: 12,
            color: DevHabitatColors.textSecondary,
          ),
        ),
        if (isOwnMessage) ...[
          const SizedBox(width: 4),
          Icon(
            message.readBy.length > 1 ? Icons.done_all : Icons.done,
            size: 16,
            color: message.readBy.length > 1
                ? DevHabitatColors.primaryBlue
                : DevHabitatColors.textSecondary,
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
