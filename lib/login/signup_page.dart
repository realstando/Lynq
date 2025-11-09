import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _firstName,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _lastName,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                  ),
                ),
              ],
            ),
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final fName = _firstName.text;
                    final lName = _lastName.text;
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final col = FirebaseFirestore.instance.collection('students');
                      final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);
                      await col.doc(userCredential.user!.uid).set({
                        'first_name': fName,
                        'last_name': lName,
                        'email': email,
                      });
                      clearText();
                      if (!mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login/',
                        (routes) => false,
                      );
                    } on FirebaseAuthException catch (e) {
                      String error;
                      if (e.code == 'weak-password') {
                        error = 'The password provided is too weak.';
                      } else if (e.code == 'email-already-in-use') {
                        error = 'The account already exists for that email.';
                      } else if (e.code == 'invalid-email') {
                        error = 'The email address is not valid.';
                      } else {
                        error = 'An unknown error has occurred.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('An error occurred. Please try again.')),
                      );
                    }
                  },
                  child: const Text('Student Sign Up'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final fName = _firstName.text;
                    final lName = _lastName.text;
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final col = FirebaseFirestore.instance.collection('signup_advisors');
                      await col.add({
                        'first_name': fName,
                        'last_name': lName,
                        'email': email,
                        'password': password,
                      });
                      clearText();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login/',
                        (routes) => false,
                      );
                    } on FirebaseAuthException catch (e) {
                      String error;
                      if (e.code == 'weak-password') {
                        error = 'The password provided is too weak.';
                      } else if (e.code == 'email-already-in-use') {
                        error = 'The account already exists for that email.';
                      } else if (e.code == 'invalid-email') {
                        error = 'The email address is not valid.';
                      } else {
                        error = 'An unknown error has occurred.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('An error occurred. Please try again.')),
                      );
                    }
                  },
                  child: const Text('Advisor Sign Up'),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login/',
                  (route) => false,
                );
              },
              child: const Text('Already registered? Login here.'),
            )
          ],
        ),
      ),
    );
  }

  Widget clearText() {
    _email.clear();
    _password.clear();
    _firstName.clear();
    _lastName.clear();
    return const Text('');
  }
}
