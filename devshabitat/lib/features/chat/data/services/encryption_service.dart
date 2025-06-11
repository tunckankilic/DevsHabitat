import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as crypto_package;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/message.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const String _userKeyId = 'user_encryption_key';
  static const String _conversationKeyPrefix = 'conv_key_';

  late crypto_package.Key _key;
  late crypto_package.IV _iv;
  late crypto_package.Encrypter _encrypter;

  Future<void> initialize() async {
    // In a real app, you would securely store and retrieve these
    final keyString = 'your-32-character-secret-key-here';
    final ivString = 'your-16-character-iv-here';

    _key = crypto_package.Key.fromUtf8(keyString);
    _iv = crypto_package.IV.fromUtf8(ivString);
    _encrypter = crypto_package.Encrypter(crypto_package.AES(_key));
  }

  // KEY MANAGEMENT

  Future<crypto_package.Key> _getUserEncryptionKey() async {
    String? keyString = await _storage.read(key: _userKeyId);

    if (keyString == null) {
      // Generate new key for first-time user
      final key = crypto_package.Key.fromSecureRandom(32);
      keyString = key.base64;
      await _storage.write(key: _userKeyId, value: keyString);
      return key;
    }

    return crypto_package.Key.fromBase64(keyString);
  }

  Future<crypto_package.Key> _getConversationKey(String conversationId) async {
    final keyId = '$_conversationKeyPrefix$conversationId';
    String? keyString = await _storage.read(key: keyId);

    if (keyString == null) {
      // Generate conversation-specific key
      final key = crypto_package.Key.fromSecureRandom(32);
      keyString = key.base64;
      await _storage.write(key: keyId, value: keyString);
      return key;
    }

    return crypto_package.Key.fromBase64(keyString);
  }

  // MESSAGE ENCRYPTION

  Future<EncryptedMessage> encryptMessage({
    required String content,
    required String conversationId,
    MessageType messageType = MessageType.text,
  }) async {
    try {
      final conversationKey = await _getConversationKey(conversationId);
      final conversationEncrypter =
          crypto_package.Encrypter(crypto_package.AES(conversationKey));
      final iv = crypto_package.IV.fromSecureRandom(16);

      // Create message payload
      final messagePayload = {
        'content': content,
        'type': messageType.name,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'version': '1.0',
      };

      final jsonPayload = jsonEncode(messagePayload);
      final encrypted = conversationEncrypter.encrypt(jsonPayload, iv: iv);

      // Create message hash for integrity
      final hash = sha256.convert(utf8.encode(jsonPayload)).toString();

      return EncryptedMessage(
        encryptedContent: encrypted.base64,
        iv: iv.base64,
        hash: hash,
        encryptionVersion: '1.0',
      );
    } catch (e) {
      throw EncryptionException('Şifreleme başarısız: ${e.toString()}');
    }
  }

  Future<DecryptedMessage> decryptMessage({
    required EncryptedMessage encryptedMessage,
    required String conversationId,
  }) async {
    try {
      final conversationKey = await _getConversationKey(conversationId);
      final conversationEncrypter =
          crypto_package.Encrypter(crypto_package.AES(conversationKey));

      final iv = crypto_package.IV.fromBase64(encryptedMessage.iv);
      final encrypted = crypto_package.Encrypted.fromBase64(
          encryptedMessage.encryptedContent);

      final decryptedJson = conversationEncrypter.decrypt(encrypted, iv: iv);
      final messagePayload = jsonDecode(decryptedJson) as Map<String, dynamic>;

      // Verify message integrity
      final computedHash =
          sha256.convert(utf8.encode(decryptedJson)).toString();
      if (computedHash != encryptedMessage.hash) {
        throw EncryptionException('Mesaj bütünlük kontrolü başarısız');
      }

      return DecryptedMessage(
        content: messagePayload['content'] as String,
        messageType: MessageType.values.firstWhere(
          (type) => type.name == messagePayload['type'],
          orElse: () => MessageType.text,
        ),
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          messagePayload['timestamp'] as int,
        ),
        version: messagePayload['version'] as String,
      );
    } catch (e) {
      throw EncryptionException('Şifre çözme başarısız: ${e.toString()}');
    }
  }

  //  BATCH OPERATIONS

  Future<List<EncryptedMessage>> encryptBatch({
    required List<String> contents,
    required String conversationId,
    MessageType messageType = MessageType.text,
  }) async {
    final results = <EncryptedMessage>[];

    for (final content in contents) {
      final encrypted = await encryptMessage(
        content: content,
        conversationId: conversationId,
        messageType: messageType,
      );
      results.add(encrypted);
    }

    return results;
  }

  Future<List<DecryptedMessage>> decryptBatch({
    required List<EncryptedMessage> encryptedMessages,
    required String conversationId,
  }) async {
    final results = <DecryptedMessage>[];

    for (final encrypted in encryptedMessages) {
      try {
        final decrypted = await decryptMessage(
          encryptedMessage: encrypted,
          conversationId: conversationId,
        );
        results.add(decrypted);
      } catch (e) {
        // Skip corrupted messages, log error
        print('Mesaj şifresi çözülemedi: $e');
      }
    }

    return results;
  }

  //  KEY ROTATION

  Future<void> rotateConversationKey(String conversationId) async {
    final keyId = '$_conversationKeyPrefix$conversationId';
    await _storage.delete(key: keyId);
    // Next encryption will generate new key
  }

  Future<void> rotateUserKey() async {
    await _storage.delete(key: _userKeyId);
    await initialize();
  }

  //  UTILITY METHODS

  Future<bool> isEncryptionEnabled() async {
    return await _storage.containsKey(key: _userKeyId);
  }

  Future<void> clearAllKeys() async {
    await _storage.deleteAll();
  }

  String generateMessageId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch;
    final input = '$timestamp-$random';
    final bytes = utf8.encode(input);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<String> encrypt(String content) async {
    // TODO: Implement encryption logic
    return content;
  }

  Future<String> decrypt(String encryptedContent) async {
    // TODO: Implement decryption logic
    return encryptedContent;
  }
}

//  DATA MODELS

class EncryptedMessage {
  final String encryptedContent;
  final String iv;
  final String hash;
  final String encryptionVersion;

  EncryptedMessage({
    required this.encryptedContent,
    required this.iv,
    required this.hash,
    required this.encryptionVersion,
  });

  Map<String, dynamic> toJson() => {
        'encryptedContent': encryptedContent,
        'iv': iv,
        'hash': hash,
        'encryptionVersion': encryptionVersion,
      };

  factory EncryptedMessage.fromJson(Map<String, dynamic> json) =>
      EncryptedMessage(
        encryptedContent: json['encryptedContent'],
        iv: json['iv'],
        hash: json['hash'],
        encryptionVersion: json['encryptionVersion'],
      );
}

class DecryptedMessage {
  final String content;
  final MessageType messageType;
  final DateTime timestamp;
  final String version;

  DecryptedMessage({
    required this.content,
    required this.messageType,
    required this.timestamp,
    required this.version,
  });
}

class EncryptionException implements Exception {
  final String message;
  EncryptionException(this.message);

  @override
  String toString() => 'EncryptionException: $message';
}

//  MESSAGE MODEL

class Message {
  final String id;
  final String content;
  final String conversationId;
  final MessageType type;
  final bool isEncrypted;
  final DateTime timestamp;
  final String senderId;

  Message({
    required this.id,
    required this.content,
    required this.conversationId,
    required this.type,
    this.isEncrypted = false,
    required this.timestamp,
    required this.senderId,
  });

  Message copyWith({
    String? id,
    String? content,
    String? conversationId,
    MessageType? type,
    bool? isEncrypted,
    DateTime? timestamp,
    String? senderId,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      conversationId: conversationId ?? this.conversationId,
      type: type ?? this.type,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
    );
  }
}

//  ENCRYPTION EXTENSIONS

extension MessageEncryption on Message {
  Future<Message> encrypt(EncryptionService service) async {
    if (content.isEmpty) return this;

    final encrypted = await service.encryptMessage(
      content: content,
      conversationId: conversationId,
      messageType: type,
    );

    return copyWith(
      content: jsonEncode(encrypted.toJson()),
      isEncrypted: true,
    );
  }

  Future<Message> decrypt(EncryptionService service) async {
    if (!isEncrypted || content.isEmpty) return this;

    try {
      final encryptedData = EncryptedMessage.fromJson(jsonDecode(content));
      final decrypted = await service.decryptMessage(
        encryptedMessage: encryptedData,
        conversationId: conversationId,
      );

      return copyWith(
        content: decrypted.content,
        isEncrypted: false,
      );
    } catch (e) {
      // Return original message if decryption fails
      return copyWith(
        content: '[Şifrelenmiş Mesaj - Şifre Çözme Başarısız]',
        isEncrypted: true,
      );
    }
  }
}
