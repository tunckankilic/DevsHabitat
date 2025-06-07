import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'dart:typed_data';

@singleton
class FirebaseService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirebaseService()
      : _auth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        _storage = FirebaseStorage.instance;

  // Auth Methods
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Firestore Methods
  Future<DocumentSnapshot> getDocument(String path) async {
    try {
      return await _firestore.doc(path).get();
    } catch (e) {
      rethrow;
    }
  }

  Future<QuerySnapshot> getCollection(String path) async {
    try {
      return await _firestore.collection(path).get();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setDocument(String path, Map<String, dynamic> data) async {
    try {
      await _firestore.doc(path).set(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDocument(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.doc(path).update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDocument(String path) async {
    try {
      await _firestore.doc(path).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Storage Methods
  Future<String> uploadFile(String path, List<int> bytes) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putData(Uint8List.fromList(bytes));
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      rethrow;
    }
  }
}
