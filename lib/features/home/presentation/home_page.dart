import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misfits/core/presentation/widgets/misfits_app_bar_title.dart';
import 'package:misfits/core/theme/theme_controller.dart';
import 'package:misfits/features/auth/data/auth_repository.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
