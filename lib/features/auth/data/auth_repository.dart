import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:misfits/features/auth/domain/auth_user.dart';
import 'package:misfits/features/auth/domain/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _kLastLoginKey = 'last_login_timestamp';
  static const Duration _kSessionValidity = Duration(hours: 24);

  // TODO: Change validity period later

  AuthRepository(this._firebaseAuth, this._googleSignIn);

  @override
  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      // Check session validity
      final lastLoginStr = await _secureStorage.read(key: _kLastLoginKey);
      if (lastLoginStr != null) {
        final lastLoginTime = DateTime.parse(lastLoginStr);
        final now = DateTime.now();
        if (now.difference(lastLoginTime) > _kSessionValidity) {
          // Session expired
          await signOut();
          return null;
        }
      } else {
        // No session timestamp found (maybe first run or cleared), treat as valid or force re-login?
        // For now, let's treat it as valid and set timestamp if missing, or maybe force logout.
        // Let's set it to now to be safe if it's missing but user is logged in.
        await _secureStorage.write(
          key: _kLastLoginKey,
          value: DateTime.now().toIso8601String(),
        );
      }

      return _mapFirebaseUser(user);
    });
  }

  @override
  AuthUser? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  AuthUser? _mapFirebaseUser(User? user) {
    if (user == null) return null;
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<AuthUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      // Note: authenticate returns non-nullable and throws on error/cancellation.

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Save login timestamp
        await _secureStorage.write(
          key: _kLastLoginKey,
          value: DateTime.now().toIso8601String(),
        );

        // Check if user exists in Firestore
        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final userDoc = await userDocRef.get();

        if (!userDoc.exists) {
          // New user -> Create record
          await userDocRef.set({
            'id': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'photoUrl': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLoginAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Existing user -> Update last login
          await userDocRef.update({
            'lastLoginAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return _mapFirebaseUser(user);
    } catch (e) {
      // Handle error (log it, rethrow, etc.)
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _secureStorage.delete(key: _kLastLoginKey);
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance, GoogleSignIn.instance);
});

final authStateProvider = StreamProvider<AuthUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
