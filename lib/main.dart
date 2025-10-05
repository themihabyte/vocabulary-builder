import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabulary_builder/firebase_options.dart';
import 'package:vocabulary_builder/services/firebase_deck_repository.dart';
import 'package:vocabulary_builder/views/card_screen.dart';
import 'providers/deck_provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData) {
          return MaterialApp(
            title: 'Memory Cards App',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: SignInScreen(
              providers: [EmailAuthProvider()],
            ),
          );
        }

        final uid = snapshot.data!.uid;

        return ChangeNotifierProvider(
          create: (_) => DeckProvider(
            repository: FirebaseDeckRepository(userId: uid),
          ),
          child: MaterialApp(
            title: 'Memory Cards App',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const CardScreen(),
          ),
        );
      },
    );
  }
}
