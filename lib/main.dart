import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internship/pages/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internship/firebase_options.dart';
import 'package:internship/widgets/app_scaffold.dart';
import 'package:internship/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship/services/sembast_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await SembastService().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: BatimentIntelligentApp()));
}

class BatimentIntelligentApp extends ConsumerWidget {
  const BatimentIntelligentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Bâtiment Intelligent',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.dark,
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
            return isLoggedIn ? const AppScaffold() : const AuthWrapper();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
