import 'package:dartz/dartz.dart';
import 'package:devshabitat/features/auth/domain/entities/user.dart';
import 'package:devshabitat/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInWithGitHub {
  final AuthRepository _authRepository;

  SignInWithGitHub(this._authRepository);

  Future<Either<Exception, User>> call() async {
    try {
      return await _authRepository.signInWithGithub();
    } catch (e) {
      return Left(Exception('GitHub girişi başarısız: ${e.toString()}'));
    }
  }
}
