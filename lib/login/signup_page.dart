import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/login/auth_helpers.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;

  static const fblaNavy = Color(0xFF0A2E7F);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  void _showDialog(String title, String message, {bool success = false}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
              color: fblaNavy, fontWeight: FontWeight.w800, fontSize: 20),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (success) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login/', (_) => false);
              }
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _signup(bool isStudent) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final fName = _firstName.text.trim();
    final lName = _lastName.text.trim();
    final email = _email.text.trim();
    final password = _password.text;

    try {
      if (isStudent) {
        final user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await user.user!.updateDisplayName("$fName $lName");
        await FirebaseFirestore.instance
            .collection('students')
            .doc(user.user!.uid)
            .set({'first_name': fName, 'last_name': lName, 'email': email});
        _showDialog('Success!', 'Student account created successfully!',
            success: true);
      } else {
        await FirebaseFirestore.instance.collection('signup_advisors').add({
          'first_name': fName,
          'last_name': lName,
          'email': email,
          'password': password,
        });
        _showDialog('Success!', 'Advisor signup request submitted!',
            success: true);
      }
      _email.clear();
      _password.clear();
      _firstName.clear();
      _lastName.clear();
    } on FirebaseAuthException catch (e) {
      String msg = switch (e.code) {
        'weak-password' => 'Password too weak.',
        'email-already-in-use' => 'Email already in use.',
        'invalid-email' => 'Invalid email format.',
        _ => 'An error occurred. Please try again.',
      };
      _showDialog('Registration Failed', msg);
    } catch (_) {
      _showDialog('Error', 'An unexpected error occurred.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0XFF0A2E7F).withValues(alpha: 0.3),
                          Color(0XFF1D52BC).withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: fblaNavy.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image(
                      image: AssetImage('assets/Lynq_Logo.png'),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Welcome Text
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: fblaNavy,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to get started',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                          child: AuthHelpers.inputField(_firstName, 'First Name',
                              icon: Icons.person_outline,
                              validator: (v) =>
                                  v!.isEmpty ? 'Required' : null)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: AuthHelpers.inputField(_lastName, 'Last Name',
                              icon: Icons.person_outline,
                              validator: (v) =>
                                  v!.isEmpty ? 'Required' : null)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AuthHelpers.inputField(_email, 'Email',
                      icon: Icons.email_outlined,
                      validator: (v) =>
                          v!.contains('@') ? null : 'Invalid email'),
                  const SizedBox(height: 16),
                  AuthHelpers.inputField(_password, 'Password',
                      obscure: _obscure,
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey.shade600),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) =>
                          (v!.length < 6) ? 'Min 6 characters' : null),
                  const SizedBox(height: 32),
                  AuthHelpers.button('Student Sign Up', () => _signup(true),
                      loading: _isLoading),
                  const SizedBox(height: 12),
                  AuthHelpers.button('Advisor Sign Up', () => _signup(false),
                      primary: false, loading: _isLoading),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      TextButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context, '/login/', (_) => false),
                        child: const Text('Login',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
