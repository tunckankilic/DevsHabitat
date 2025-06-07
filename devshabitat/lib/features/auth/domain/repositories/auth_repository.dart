import 'package:dartz/dartz.dart';
import 'package:devshabitat/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Exception, User>> signInWithEmailAndPassword(
      String email, String password);
  Future<Either<Exception, User>> signInWithGoogle();
  Future<Either<Exception, User>> signInWithGithub();
  Future<Either<Exception, User>> signInWithFacebook();
  Future<Either<Exception, User>> signInWithApple();
  Future<Either<Exception, User>> registerWithEmailAndPassword(
      String email, String password, String name);
  Future<Either<Exception, void>> signOut();
  Future<Either<Exception, User?>> getCurrentUser();
  Future<Either<Exception, void>> updateUserProfile(User user);
  Future<Either<Exception, void>> updateUserPreferences(
      Map<String, dynamic> preferences);
  Future<Either<Exception, void>> addConnection(String userId);
  Future<Either<Exception, void>> removeConnection(String userId);
  Stream<User?> get userStream;
}
