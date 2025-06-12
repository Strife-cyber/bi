import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship/firebase_options.dart';
import 'package:internship/pages/auth.dart';
import 'package:internship/pages/dashboard.dart';
import 'package:internship/services/auth_service.dart';
import 'package:internship/services/sembast_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SembastService().init();

  runApp(const ProviderScope(child: BatimentIntelligentApp()));
}

class BatimentIntelligentApp extends ConsumerWidget {
  const BatimentIntelligentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Bâtiment Intelligent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: FutureBuilder<bool>(
        future: ref.read(authServiceProvider).tryAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Something went wrong')),
            );
          } else {
            final isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? const Dashboard() : const AuthWrapper();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
