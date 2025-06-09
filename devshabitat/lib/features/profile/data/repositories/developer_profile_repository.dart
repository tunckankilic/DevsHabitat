import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devshabitat/features/profile/domain/models/developer_profile.dart';

abstract class IDeveloperProfileRepository {
  Future<DeveloperProfile> getProfile(String userId);
  Future<void> createProfile(DeveloperProfile profile);
  Future<void> updateProfile(DeveloperProfile profile);
  Future<void> deleteProfile(String userId);
  Future<List<DeveloperProfile>> searchProfiles(String query);
  Future<List<DeveloperProfile>> getFeaturedProfiles();
}

class DeveloperProfileRepository implements IDeveloperProfileRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'developer_profiles';

  DeveloperProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<DeveloperProfile> getProfile(String userId) async {
    final doc = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    if (doc.docs.isEmpty) {
      throw Exception('Profile not found');
    }

    return DeveloperProfile.fromFirestore(doc.docs.first);
  }

  @override
  Future<void> createProfile(DeveloperProfile profile) async {
    await _firestore
        .collection(_collection)
        .doc(profile.id)
        .set(profile.toMap());
  }

  @override
  Future<void> updateProfile(DeveloperProfile profile) async {
    await _firestore
        .collection(_collection)
        .doc(profile.id)
        .update(profile.toMap());
  }

  @override
  Future<void> deleteProfile(String userId) async {
    final doc = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    if (doc.docs.isNotEmpty) {
      await _firestore.collection(_collection).doc(doc.docs.first.id).delete();
    }
  }

  @override
  Future<List<DeveloperProfile>> searchProfiles(String query) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    return snapshot.docs
        .map((doc) => DeveloperProfile.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<DeveloperProfile>> getFeaturedProfiles() async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('profileCompletionScore', isGreaterThan: 0.8)
        .orderBy('profileCompletionScore', descending: true)
        .limit(10)
        .get();

    return snapshot.docs
        .map((doc) => DeveloperProfile.fromFirestore(doc))
        .toList();
  }
}
