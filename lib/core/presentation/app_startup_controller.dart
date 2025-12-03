import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';

class AppStartupController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // 1. Check for App Updates (Android only)
    if (!kIsWeb && Platform.isAndroid) {
      await _checkAndPerformUpdate();
    }

    // 2. Add other startup checks here (e.g., remote config, maintenance mode)
  }

  Future<void> _checkAndPerformUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // We want a compulsory update, so we use performImmediateUpdate.
        // This will block the user until the update is installed.
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      // If update check fails (e.g., no internet, or not installed from Play Store),
      // we log it but allow the app to proceed.
      // Blocking here would prevent users from using the app if the Play Store API fails.
      if (kDebugMode) {
        print('App Update Check Failed: $e');
      }
    }
  }
}

final appStartupProvider = AsyncNotifierProvider<AppStartupController, void>(
  () {
    return AppStartupController();
  },
);
