import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/developer_profile_repository.dart';
import '../models/developer_profile.dart';

class UpdateProfileUseCase {
  final IDeveloperProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(DeveloperProfile profile) async {
    try {
      await repository.updateProfile(profile);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
