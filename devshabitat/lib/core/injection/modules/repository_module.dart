import 'package:injectable/injectable.dart';
import 'package:devshabitat/features/chat/domain/repositories/messaging_repository.dart';
import 'package:devshabitat/features/chat/data/repositories/messaging_repository_impl.dart';
import 'package:devshabitat/features/auth/domain/repositories/auth_repository.dart';
import 'package:devshabitat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:devshabitat/features/profile/domain/repositories/developer_profile_repository.dart';
import 'package:devshabitat/features/profile/data/repositories/developer_profile_repository_impl.dart';
import 'package:devshabitat/core/services/firebase_service.dart';

@module
abstract class RepositoryModule {
  @injectable
  MessagingRepository messagingRepository() => FirebaseMessagingRepository();

  @injectable
  AuthRepository authRepository(FirebaseService firebaseService) =>
      AuthRepositoryImpl(firebaseService);

  @injectable
  IDeveloperProfileRepository developerProfileRepository(
          FirebaseService firebaseService) =>
      DeveloperProfileRepository(firebaseService);
}
