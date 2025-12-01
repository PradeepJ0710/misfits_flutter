import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misfits/core/presentation/splash_screen.dart';
import 'package:misfits/features/auth/data/auth_repository.dart';
import 'package:misfits/features/auth/domain/auth_user.dart';
import 'package:misfits/features/auth/presentation/login_page.dart';
import 'package:misfits/features/home/presentation/home_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // We use a ValueNotifier to bridge the Stream/AsyncValue to GoRouter's Listenable
  final authNotifier = ValueNotifier<AsyncValue<AuthUser?>>(
    const AsyncLoading(),
  );

  // Listen to the provider and update the notifier
  // This subscription keeps the provider alive and updates our local notifier
  ref.listen(authStateProvider, (previous, next) {
    authNotifier.value = next;
  });

  // Ensure we clean up the subscription if this provider is disposed (though usually it lives forever)
  ref.onDispose(() {
    authNotifier.dispose();
    // subscription is auto-disposed by Riverpod
  });

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable:
        authNotifier, // Router listens to this, not the provider directly
    redirect: (context, state) {
      final authState = authNotifier.value;

      // If auth state is loading, stay on splash (or redirect there)
      if (authState.isLoading) {
        return '/splash';
      }

      final isLoggingIn = state.uri.toString() == '/login';
      final isSplash = state.uri.toString() == '/splash';

      // If auth has error, go to login
      if (authState.hasError) {
        return isLoggingIn ? null : '/login';
      }

      final isLoggedIn = authState.value != null;

      if (isLoggedIn) {
        // If logged in and on splash or login, go to home
        if (isSplash || isLoggingIn) {
          return '/home';
        }
      } else {
        // If not logged in and not on login, go to login
        if (!isLoggingIn) {
          return '/login';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
  );
});
