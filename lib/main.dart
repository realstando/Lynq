import 'package:coding_prog/Annoucements/announcements_page.dart';
import 'package:coding_prog/login/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/login/login_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LYNQ',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoginPage(),
        backgroundColor: Colors.white,
      ),
      routes: {
      '/login/': (context) => const LoginPage(),
      '/signup/': (context) => const SignupPage(),
      '/announcements/': (context) => const AnnouncementsPage(),
      }
    );
  }
}
