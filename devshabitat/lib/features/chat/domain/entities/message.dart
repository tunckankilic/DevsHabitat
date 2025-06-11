import 'package:equatable/equatable.dart';
import '../../data/services/encryption_service.dart';

enum MessageType {
  text,
  image,
  file,
  code,
  voice,
  video,
}

class Message extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final Map<String, DateTime> readBy;
  final String? replyToMessageId;
  final List<MessageAttachment>? attachments;
  final bool isEdited;
  final DateTime? editedAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.readBy,
    this.replyToMessageId,
    this.attachments,
    this.isEdited = false,
    this.editedAt,
  });

  Future<Message> encrypt(EncryptionService encryptionService) async {
    final encryptedMessage = await encryptionService.encryptMessage(
      content: content,
      conversationId: conversationId,
      messageType: type,
    );
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      content: encryptedMessage.encryptedContent,
      type: type,
      timestamp: timestamp,
      readBy: readBy,
      replyToMessageId: replyToMessageId,
      attachments: attachments,
      isEdited: isEdited,
      editedAt: editedAt,
    );
  }

  Future<Message> decrypt(EncryptionService encryptionService) async {
    final decryptedMessage = await encryptionService.decryptMessage(
      encryptedMessage: EncryptedMessage(
        encryptedContent: content,
        iv: '', // TODO: Store IV with message
        hash: '', // TODO: Store hash with message
        encryptionVersion: '1.0',
      ),
      conversationId: conversationId,
    );
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      content: decryptedMessage.content,
      type: decryptedMessage.messageType,
      timestamp: decryptedMessage.timestamp,
      readBy: readBy,
      replyToMessageId: replyToMessageId,
      attachments: attachments,
      isEdited: isEdited,
      editedAt: editedAt,
    );
  }

  factory Message.fromFirestore(Map<String, dynamic> doc) {
    return Message(
      id: doc['id'] as String,
      conversationId: doc['conversationId'] as String,
      senderId: doc['senderId'] as String,
      content: doc['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${doc['type']}',
        orElse: () => MessageType.text,
      ),
      timestamp: (doc['timestamp'] as DateTime),
      readBy: Map<String, DateTime>.from(doc['readBy'] as Map),
      replyToMessageId: doc['replyToMessageId'] as String?,
      attachments: (doc['attachments'] as List?)
          ?.map((e) => MessageAttachment.fromMap(e as Map<String, dynamic>))
          .toList(),
      isEdited: doc['isEdited'] as bool? ?? false,
      editedAt: doc['editedAt'] as DateTime?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'type': type.toString().split('.').last,
      'timestamp': timestamp,
      'readBy': readBy,
      'replyToMessageId': replyToMessageId,
      'attachments': attachments?.map((e) => e.toMap()).toList(),
      'isEdited': isEdited,
      'editedAt': editedAt,
    };
  }

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    Map<String, DateTime>? readBy,
    String? replyToMessageId,
    List<MessageAttachment>? attachments,
    bool? isEdited,
    DateTime? editedAt,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      readBy: readBy ?? this.readBy,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      attachments: attachments ?? this.attachments,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        content,
        type,
        timestamp,
        readBy,
        replyToMessageId,
        attachments,
        isEdited,
        editedAt,
      ];
}

class MessageAttachment extends Equatable {
  final String url;
  final String fileName;
  final int fileSize;
  final String mimeType;

  const MessageAttachment({
    required this.url,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
  });

  factory MessageAttachment.fromMap(Map<String, dynamic> map) {
    return MessageAttachment(
      url: map['url'] as String,
      fileName: map['fileName'] as String,
      fileSize: map['fileSize'] as int,
      mimeType: map['mimeType'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'fileName': fileName,
      'fileSize': fileSize,
      'mimeType': mimeType,
    };
  }

  @override
  List<Object?> get props => [url, fileName, fileSize, mimeType];
}
