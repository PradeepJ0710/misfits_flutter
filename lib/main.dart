import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:misfits/config/routes/app_router.dart';
import 'package:misfits/core/theme/app_theme.dart';
import 'package:misfits/core/theme/theme_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:misfits/core/presentation/app_startup_controller.dart';
import 'package:misfits/core/presentation/splash_screen.dart';
import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    developer.log("Handling a background message: ${message.messageId}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await GoogleSignIn.instance.initialize();

  runApp(const ProviderScope(child: AppStartupWidget()));
}

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This triggers the build() method of AppStartupController
    final startupState = ref.watch(appStartupProvider);

    return startupState.when(
      // 1. Success: Show the real app
      data: (_) => const MyApp(),

      // 2. Loading: Show a native-like splash screen
      loading: () => const MaterialApp(
        home: SplashScreen(), // Or a simpler NativeSplashScreen widget
        debugShowCheckedModeBanner: false,
      ),

      // 3. Error: Still show real app
      error: (e, st) => const MyApp(),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode =
        ref.watch(themeControllerProvider).asData?.value ?? ThemeMode.dark;

    return MaterialApp.router(
      title: 'Misfits',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
