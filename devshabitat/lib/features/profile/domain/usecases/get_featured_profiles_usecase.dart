import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/developer_profile_repository.dart';
import '../models/developer_profile.dart';

class GetFeaturedProfilesUseCase {
  final IDeveloperProfileRepository repository;

  GetFeaturedProfilesUseCase(this.repository);

  Future<Either<Failure, List<DeveloperProfile>>> call() async {
    try {
      final profiles = await repository.getFeaturedProfiles();
      return Right(profiles);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
