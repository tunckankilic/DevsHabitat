import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../theme/dev_habitat_colors.dart';
import '../../features/chat/domain/entities/message.dart';
import '../../features/chat/domain/repositories/messaging_repository.dart';

class ErrorHandler {
  static Future<void> handleError(
    dynamic error,
    StackTrace stackTrace, {
    bool showSnackBar = true,
    BuildContext? context,
  }) async {
    // Report error to Firebase Crashlytics
    await FirebaseCrashlytics.instance.recordError(error, stackTrace);

    // Determine error message
    String errorMessage = _getErrorMessage(error);

    // Show SnackBar
    if (showSnackBar && context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: DevHabitatColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    // Print error to console
    debugPrint('Error: $errorMessage');
    debugPrint('Stack Trace: $stackTrace');
  }

  static String _getErrorMessage(dynamic error) {
    if (error is PlatformException) {
      return error.message ?? 'A platform error occurred';
    } else if (error is TimeoutException) {
      return 'Operation timed out';
    } else if (error is MessagingException) {
      return error.message;
    } else {
      return 'An unexpected error occurred';
    }
  }

  static Future<bool> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Future<void> handleConnectivityError(BuildContext context) async {
    if (!await checkConnectivity()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check your internet connection'),
          backgroundColor: DevHabitatColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
