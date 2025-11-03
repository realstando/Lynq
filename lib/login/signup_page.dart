import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(child: const Text('Hello World'));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredential = FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                  _email.clear();
                  _password.clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/',
                    (routes) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                  } else if (e.code == 'email-already-in-use') {
                  } else if (e.code == 'invalid-email') {}
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login/',
                  (route) => false,
                );
              },
              child: const Text('Already registered? Login here.'),
            ),
          ],
        ),
      ),
    );
  }
}
