import 'sembast_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SembastService _sembast = SembastService();
  final String _userStore = 'user';
  final String _userKey = 'current';

  /// Email & Password Signup
  Future<User?> signUpWithEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return await _cacheUser(cred.user);
  }

  /// Email & Password Sign-In
  Future<User?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return await _cacheUser(cred.user);
  }

  /// Google Sign-In
  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw FirebaseAuthException(code: 'ABORTED_BY_USER');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    return await _cacheUser(cred.user);
  }

  /// GitHub Sign-In
  Future<User?> signInWithGitHub() async {
    final provider = GithubAuthProvider();
    final cred = await _auth.signInWithProvider(provider);
    return await _cacheUser(cred.user);
  }

  /// Get current signed-in user (online or offline fallback)
  Future<Map<String, dynamic>?> getLocalUser() async {
    return await _sembast.get(_userStore, _userKey);
  }

  /// Check if Firebase has a user
  User? get currentUser => _auth.currentUser;

  /// Sign Out and clear local data
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await _sembast.delete(_userStore, _userKey);
  }

  /// Cache user locally
  Future<User?> _cacheUser(User? user) async {
    if (user == null) return null;

    final data = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'provider': user.providerData.isNotEmpty ? user.providerData[0].providerId : 'email',
    };

    await _sembast.set(_userStore, _userKey, data);
    return user;
  }

  /// Try to auto-login using cached user (offline support)
  Future<bool> tryAutoLogin() async {
    final user = await getLocalUser();
    return user != null;
  }
}
