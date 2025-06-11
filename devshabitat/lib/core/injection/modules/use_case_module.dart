import 'package:injectable/injectable.dart';
import 'package:devshabitat/features/auth/domain/repositories/auth_repository.dart';
import 'package:devshabitat/features/auth/domain/usecases/sign_in_with_github.dart';
import 'package:devshabitat/features/profile/domain/repositories/developer_profile_repository.dart';
import 'package:devshabitat/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:devshabitat/features/profile/domain/usecases/get_featured_profiles_usecase.dart';

@module
abstract class UseCaseModule {
  @injectable
  SignInWithGitHub signInWithGitHubUseCase(AuthRepository repository) =>
      SignInWithGitHub(repository);

  @injectable
  GetProfileUseCase getProfileUseCase(IDeveloperProfileRepository repository) =>
      GetProfileUseCase(repository);

  @injectable
  GetFeaturedProfilesUseCase getFeaturedProfilesUseCase(
    IDeveloperProfileRepository repository,
  ) =>
      GetFeaturedProfilesUseCase(repository);
}
