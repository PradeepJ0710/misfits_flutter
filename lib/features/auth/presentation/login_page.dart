import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misfits/features/auth/data/auth_repository.dart';
import 'package:misfits/features/auth/presentation/auth_controller.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state to redirect when logged in
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          // Navigate to Home (TODO: Create Home Page)
          // context.go('/home');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${user.displayName}!')),
          );
        }
      });
    });

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_cricket, size: 100, color: Colors.green),
            const SizedBox(height: 32),
            Text('Misfits', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 48),
            if (authState.isLoading)
              const CircularProgressIndicator()
            else
              FilledButton.icon(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).signInWithGoogle();
                },
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
              ),
            if (authState.hasError)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${authState.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
