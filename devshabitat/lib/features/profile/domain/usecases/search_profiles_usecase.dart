import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/developer_profile_repository.dart';
import '../models/developer_profile.dart';

class SearchProfilesUseCase {
  final IDeveloperProfileRepository repository;

  SearchProfilesUseCase(this.repository);

  Future<Either<Failure, List<DeveloperProfile>>> call(String query) async {
    try {
      final profiles = await repository.searchProfiles(query);
      return Right(profiles);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
