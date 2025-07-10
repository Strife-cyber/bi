import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internship/firebase_options.dart';
import 'package:internship/services/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Make sure Firebase is initialized
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  });

  group('AuthService Integration Tests (No Mock)', () {
    final authService = AuthService();
    final email = 'testuser${DateTime.now().millisecondsSinceEpoch}@example.com';
    final password = 'testPassword123';

    test('Sign up with email and password', () async {
      final user = await authService.signUpWithEmail(email, password);
      expect(user, isNotNull);
      expect(user?.email, email);
      debugPrint('User signed up: ${user?.email}');
    });

    test('Sign in with email and password', () async {
      final user = await authService.signInWithEmail(email, password);
      expect(user, isNotNull);
      expect(user?.email, email);
    });

    test('Try auto login after caching user', () async {
      final result = await authService.tryAutoLogin();
      expect(result, true);
    });

    test('Sign out clears local and remote user', () async {
      await authService.signOut();
      expect(authService.currentUser, isNull);
      final cached = await authService.getLocalUser();
      expect(cached, isNull);
    });
  });
}
