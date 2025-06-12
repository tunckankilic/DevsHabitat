import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../entities/message.dart';
import '../entities/conversation.dart';

class MessagingException implements Exception {
  final String message;

  MessagingException(this.message);

  @override
  String toString() => message;
}

abstract class MessagingRepository {
  Stream<List<Conversation>> getConversations(String userId);
  Stream<List<Message>> getMessages(String conversationId);
  Future<void> sendMessage(Message message);
  Future<void> updateMessage(Message message);
  Future<void> deleteMessage(String messageId, String conversationId);
  Future<void> markMessageAsRead(
      String messageId, String conversationId, String userId);
  Future<void> createConversation(Conversation conversation);
  Future<void> updateConversation(Conversation conversation);
  Future<void> deleteConversation(String conversationId);
  Future<String> uploadAttachment(String path, Uint8List bytes);
  Future<void> deleteAttachment(String path);
  Future<void> blockUser(String userId, String blockedUserId);
}

class FirebaseMessagingRepository implements MessagingRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  FirebaseMessagingRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Stream<List<Conversation>> getConversations(String userId) {
    return _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Conversation.fromFirestore(doc.data()))
          .toList();
    });
  }

  @override
  Stream<List<Message>> getMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Message.fromFirestore(doc.data()))
          .toList();
    });
  }

  @override
  Future<void> sendMessage(Message message) async {
    final batch = _firestore.batch();

    // Add message to messages subcollection
    final messageRef = _firestore
        .collection('conversations')
        .doc(message.conversationId)
        .collection('messages')
        .doc(message.id);
    batch.set(messageRef, message.toFirestore());

    // Update conversation with last message info
    final conversationRef =
        _firestore.collection('conversations').doc(message.conversationId);
    batch.update(conversationRef, {
      'lastMessageId': message.id,
      'lastMessageTime': message.timestamp,
      'lastReadBy.${_auth.currentUser?.uid}': message.timestamp,
    });

    await batch.commit();
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
    // Note: In a real app, you might want to implement soft delete
    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId)
        .delete();
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
    // Note: In a real app, you might want to implement soft delete
    await _firestore.collection('conversations').doc(conversationId).delete();
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
