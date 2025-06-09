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
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../shared/services/firebase_service.dart' as _i924;
import '../../shared/services/storage_service.dart' as _i304;
import '../network/api_client.dart' as _i557;
import '../network/network_info.dart' as _i932;

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
    gh.singleton<_i557.ApiClient>(() => _i557.ApiClient());
    gh.singleton<_i924.FirebaseService>(() => _i924.FirebaseService());
    gh.singleton<_i304.StorageService>(
        () => _i304.StorageService(gh<_i460.SharedPreferences>()));
    gh.factory<_i932.NetworkInfo>(
        () => _i932.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()));
    return this;
  }
}
