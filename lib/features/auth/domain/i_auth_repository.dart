import 'package:misfits/features/auth/domain/auth_user.dart';

abstract class IAuthRepository {
  Stream<AuthUser?> get authStateChanges;
  Future<AuthUser?> signInWithGoogle();
  Future<void> signOut();
  AuthUser? get currentUser;
}
