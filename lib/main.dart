import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(248, 232, 96, 72)),
      ),
      home: StreamBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return const ChatScreen();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          return const Authscreen();
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}
