import 'package:flutter/material.dart';
import 'package:internship/pages/login.dart';
import 'package:internship/pages/signup.dart';

// Main Auth Wrapper
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: isLogin
            ? LoginPage(
                key: const ValueKey('login'),
                onSwitchToSignup: () => setState(() => isLogin = false),
              )
            : SignupPage(
                key: const ValueKey('signup'),
                onSwitchToLogin: () => setState(() => isLogin = true),
              ),
      ),
    );
  }
}