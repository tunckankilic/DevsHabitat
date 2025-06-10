import 'package:injectable/injectable.dart';
import 'package:devshabitat/core/services/firebase_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@module
abstract class ServiceModule {
  @singleton
  FirebaseService firebaseService() => FirebaseService();

  @singleton
  InternetConnectionChecker internetConnectionChecker() =>
      InternetConnectionChecker();
}
