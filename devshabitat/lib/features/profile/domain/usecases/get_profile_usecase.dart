import 'package:equatable/equatable.dart';
import '../models/developer_profile.dart';
import '../repositories/developer_profile_repository.dart';

class GetProfileUseCase {
  final IDeveloperProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<DeveloperProfile> call(String userId) async {
    return await repository.getProfile(userId);
  }
}
