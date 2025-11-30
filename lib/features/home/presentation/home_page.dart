import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:misfits/core/presentation/widgets/misfits_app_bar_title.dart';
import 'package:misfits/core/services/notification_service.dart';
import 'package:misfits/core/theme/theme_controller.dart';
import 'package:misfits/features/auth/data/auth_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    final notificationService = NotificationService();
    await notificationService.initialize();

    // Setup interaction handling (tap on notification)
    if (mounted) {
      final router = GoRouter.of(context);
      await notificationService.setupInteractedMessage(router);
    }

    // Get and print token for testing
    final token = await notificationService.getFcmToken();
    if (kDebugMode) {
      developer.log('FCM Token: $token');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(themeControllerProvider).asData?.value ?? ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const MisfitsAppBarTitle(title: 'Misfits'),
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeControllerProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to Misfits!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
