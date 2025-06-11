import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/messaging_repository.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Stream<List<Conversation>> getConversations(String userId) {
    return _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Conversation.fromFirestore(doc.data()))
            .toList());
  }

  @override
  Stream<List<Message>> getMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromFirestore(doc.data()))
            .toList());
  }

  @override
  Future<void> sendMessage(Message message) async {
    final batch = _firestore.batch();

    final messageRef = _firestore
        .collection('conversations')
        .doc(message.conversationId)
        .collection('messages')
        .doc(message.id);

    batch.set(messageRef, message.toFirestore());

    final conversationRef =
        _firestore.collection('conversations').doc(message.conversationId);

    batch.update(conversationRef, {
      'lastMessage': message.content,
      'lastMessageId': message.id,
      'lastMessageTime': message.timestamp,
      'updatedAt': message.timestamp,
      'unreadCounts': {
        for (String id in message.readBy.keys)
          id: (message.readBy[id] != null) ? 0 : 1
      },
    });

    await batch.commit();
  }

  @override
  Future<void> createConversation(Conversation conversation) async {
    await _firestore
        .collection('conversations')
        .doc(conversation.id)
        .set(conversation.toFirestore());
  }

  @override
  Future<void> updateConversation(Conversation conversation) async {
    await _firestore
        .collection('conversations')
        .doc(conversation.id)
        .update(conversation.toFirestore());
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    await _firestore.collection('conversations').doc(conversationId).delete();
  }

  @override
  Future<void> updateMessage(Message message) async {
    await _firestore
        .collection('conversations')
        .doc(message.conversationId)
        .collection('messages')
        .doc(message.id)
        .update(message.toFirestore());
  }

  @override
  Future<void> deleteMessage(String messageId, String conversationId) async {
    final batch = _firestore.batch();

    // Mesajı sil
    final messageRef = _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId);
    batch.delete(messageRef);

    // Son mesajı güncelle
    final conversationRef =
        _firestore.collection('conversations').doc(conversationId);
    final conversation = await conversationRef.get();

    if (conversation.exists &&
        conversation.data()?['lastMessageId'] == messageId) {
      // Son mesaj silindiyse, bir önceki mesajı bul
      final previousMessages = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (previousMessages.docs.isNotEmpty) {
        final lastMessage =
            Message.fromFirestore(previousMessages.docs.first.data());
        batch.update(conversationRef, {
          'lastMessage': lastMessage.content,
          'lastMessageId': lastMessage.id,
          'lastMessageTime': lastMessage.timestamp,
          'updatedAt': lastMessage.timestamp,
        });
      } else {
        // Hiç mesaj kalmadıysa
        batch.update(conversationRef, {
          'lastMessage': null,
          'lastMessageId': null,
          'lastMessageTime': null,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }

    await batch.commit();
  }

  @override
  Future<void> markMessageAsRead(
      String messageId, String conversationId, String userId) async {
    final batch = _firestore.batch();

    // Mesajı okundu olarak işaretle
    final messageRef = _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId);
    batch.update(messageRef, {
      'readBy.$userId': FieldValue.serverTimestamp(),
    });

    // Konuşmanın okunmamış mesaj sayısını güncelle
    final conversationRef =
        _firestore.collection('conversations').doc(conversationId);
    batch.update(conversationRef, {
      'unreadCounts.$userId': 0,
      'lastReadBy.$userId': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  Future<String> uploadAttachment(String path, Uint8List bytes) async {
    final ref = _storage.ref().child(path);
    await ref.putData(bytes);
    return await ref.getDownloadURL();
  }

  @override
  Future<void> deleteAttachment(String path) async {
    await _storage.ref().child(path).delete();
  }

  @override
  Future<void> blockUser(String userId, String blockedUserId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('blockedUsers')
        .doc(blockedUserId)
        .set({
      'blockedAt': FieldValue.serverTimestamp(),
    });
  }
}
