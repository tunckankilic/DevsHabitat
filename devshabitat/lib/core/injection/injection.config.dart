// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;

import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/sign_in_with_github.dart' as _i504;
import '../../features/chat/domain/repositories/messaging_repository.dart'
    as _i258;
import '../../features/chat/presentation/blocs/chat_bloc.dart' as _i48;
import '../../features/chat/presentation/blocs/conversation_list_bloc.dart'
    as _i597;
import '../../features/profile/domain/repositories/developer_profile_repository.dart'
    as _i384;
import '../../features/profile/domain/usecases/get_featured_profiles_usecase.dart'
    as _i234;
import '../../features/profile/domain/usecases/get_profile_usecase.dart'
    as _i965;
import '../../shared/services/firebase_service.dart' as _i924;
import '../network/network_info.dart' as _i932;
import '../services/firebase_service.dart' as _i758;
import 'modules/bloc_module.dart' as _i539;
import 'modules/repository_module.dart' as _i554;
import 'modules/service_module.dart' as _i681;
import 'modules/use_case_module.dart' as _i249;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final repositoryModule = _$RepositoryModule();
    final serviceModule = _$ServiceModule();
    final blocModule = _$BlocModule();
    final useCaseModule = _$UseCaseModule();
    gh.factory<_i258.MessagingRepository>(
        () => repositoryModule.messagingRepository());
    gh.factory<_i787.AuthRepository>(
        () => repositoryModule.authRepository(gh<_i758.FirebaseService>()));
    gh.factory<_i384.IDeveloperProfileRepository>(() => repositoryModule
        .developerProfileRepository(gh<_i758.FirebaseService>()));
    gh.singleton<_i758.FirebaseService>(() => serviceModule.firebaseService());
    gh.singleton<_i973.InternetConnectionChecker>(
        () => serviceModule.internetConnectionChecker());
    gh.singleton<_i924.FirebaseService>(() => _i924.FirebaseService());
    gh.factory<_i48.ChatBloc>(
        () => blocModule.chatBloc(gh<_i258.MessagingRepository>()));
    gh.factory<_i597.ConversationListBloc>(
        () => blocModule.conversationListBloc(gh<_i258.MessagingRepository>()));
    gh.factory<_i504.SignInWithGitHub>(() =>
        useCaseModule.signInWithGitHubUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i932.NetworkInfo>(
        () => _i932.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()));
    gh.factory<_i965.GetProfileUseCase>(() => useCaseModule
        .getProfileUseCase(gh<_i384.IDeveloperProfileRepository>()));
    gh.factory<_i234.GetFeaturedProfilesUseCase>(() => useCaseModule
        .getFeaturedProfilesUseCase(gh<_i384.IDeveloperProfileRepository>()));
    return this;
  }
}

class _$RepositoryModule extends _i554.RepositoryModule {}

class _$ServiceModule extends _i681.ServiceModule {}

class _$BlocModule extends _i539.BlocModule {}

class _$UseCaseModule extends _i249.UseCaseModule {}
