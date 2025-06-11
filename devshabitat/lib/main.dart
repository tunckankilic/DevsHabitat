import 'dart:io';
import 'package:devshabitat/core/config/firebase/firebase_options.dart';
import 'package:devshabitat/core/injection/injection.dart';
import 'package:devshabitat/core/config/routes/app_router.dart';
import 'package:devshabitat/core/theme/devhabitat_theme.dart';
import 'package:devshabitat/core/services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Service
  final firebaseService = FirebaseService();
  await firebaseService.initialize();

  // Initialize Hydrated Bloc
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  HydratedBloc.storage = storage;

  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'DevHabitat',
          debugShowCheckedModeBanner: false,
          theme: DevHabitatTheme.lightTheme,
          darkTheme: DevHabitatTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
