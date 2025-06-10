import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:devshabitat/core/theme/devhabitat_theme.dart';
import 'package:devshabitat/core/theme/devhabitat_colors.dart';
import '../../domain/entities/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isOwnMessage;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isOwnMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isOwnMessage) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isOwnMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isOwnMessage) _buildSenderName(),
                _buildMessageContent(),
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
          : DevHabitatColors.primaryPurple,
      child: Text(
        message.senderId.substring(0, 1).toUpperCase(),
        style: DevHabitatTheme.labelMedium.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSenderName() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        message.senderId,
        style: DevHabitatTheme.labelSmall.copyWith(
          color: DevHabitatColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.text:
        return _buildTextMessage();
      case MessageType.image:
        return _buildImageMessage();
      case MessageType.file:
        return _buildFileMessage();
      case MessageType.code:
        return _buildCodeMessage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isOwnMessage
            ? DevHabitatColors.primaryBlue
            : DevHabitatColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message.content,
        style: DevHabitatTheme.bodyMedium.copyWith(
          color: isOwnMessage ? Colors.white : DevHabitatColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: message.attachments.first.url,
        placeholder: (context, url) => Container(
          width: 200,
          height: 200,
          color: DevHabitatColors.darkSurface,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 200,
          height: 200,
          color: DevHabitatColors.darkSurface,
          child: const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildFileMessage() {
    final attachment = message.attachments.first;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOwnMessage
            ? DevHabitatColors.primaryBlue
            : DevHabitatColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.white),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                attachment.fileName,
                style: DevHabitatTheme.labelMedium.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                _formatFileSize(attachment.fileSize),
                style: DevHabitatTheme.labelSmall.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOwnMessage
            ? DevHabitatColors.primaryBlue
            : DevHabitatColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Code Snippet',
            style: DevHabitatTheme.labelMedium.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DevHabitatColors.darkBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message.content,
              style: DevHabitatTheme.bodySmall.copyWith(
                color: Colors.white,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatTime(message.timestamp),
            style: DevHabitatTheme.labelSmall.copyWith(
              color: DevHabitatColors.textTertiary,
            ),
          ),
          if (isOwnMessage) ...[
            const SizedBox(width: 4),
            Icon(
              message.readBy.length > 1 ? Icons.done_all : Icons.done,
              size: 16,
              color: message.readBy.length > 1
                  ? DevHabitatColors.primaryBlue
                  : DevHabitatColors.textTertiary,
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
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
