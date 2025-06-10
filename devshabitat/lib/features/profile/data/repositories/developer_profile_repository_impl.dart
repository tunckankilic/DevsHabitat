import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:devshabitat/features/profile/domain/repositories/developer_profile_repository.dart';
import 'package:devshabitat/features/profile/domain/models/developer_profile.dart';
import 'package:devshabitat/core/error/failures.dart';
import 'package:devshabitat/core/services/firebase_service.dart';

@Injectable(as: IDeveloperProfileRepository)
class DeveloperProfileRepository implements IDeveloperProfileRepository {
  final FirebaseService _firebaseService;

  DeveloperProfileRepository(this._firebaseService);

  @override
  Future<DeveloperProfile> getProfile(String userId) async {
    final doc = await _firebaseService.firestore
        .collection('developer_profiles')
        .doc(userId)
        .get();
    return DeveloperProfile.fromJson(doc.data()!);
  }

  @override
  Future<List<DeveloperProfile>> searchProfiles(String query) async {
    final snapshot = await _firebaseService.firestore
        .collection('developer_profiles')
        .where('searchKeywords', arrayContains: query.toLowerCase())
        .get();
    return snapshot.docs
        .map((doc) => DeveloperProfile.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<DeveloperProfile>> getFeaturedProfiles() async {
    final snapshot = await _firebaseService.firestore
        .collection('developer_profiles')
        .where('isFeatured', isEqualTo: true)
        .limit(10)
        .get();
    return snapshot.docs
        .map((doc) => DeveloperProfile.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<Either<Failure, void>> updateProfile(DeveloperProfile profile) async {
    try {
      await _firebaseService.firestore
          .collection('developer_profiles')
          .doc(profile.id)
          .update(profile.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(String userId) async {
    try {
      await _firebaseService.firestore
          .collection('developer_profiles')
          .doc(userId)
          .delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
