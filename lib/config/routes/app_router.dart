import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misfits/core/presentation/splash_screen.dart';
import 'package:misfits/features/auth/data/auth_repository.dart';
import 'package:misfits/features/auth/presentation/login_page.dart';
import 'package:misfits/features/home/presentation/home_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) async {
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
