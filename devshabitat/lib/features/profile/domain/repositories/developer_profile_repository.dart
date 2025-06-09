import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/developer_profile.dart';

abstract class IDeveloperProfileRepository {
  Future<DeveloperProfile> getProfile(String userId);
  Future<List<DeveloperProfile>> searchProfiles(String query);
  Future<List<DeveloperProfile>> getFeaturedProfiles();
  Future<Either<Failure, void>> updateProfile(DeveloperProfile profile);
  Future<Either<Failure, void>> deleteProfile(String userId);
}
