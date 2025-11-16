import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/login/auth_helpers.dart';

/// A signup page that allows users to create either a student or advisor account.
/// Students are registered directly with Firebase Auth, while advisors submit a request for approval.
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Text controllers for form inputs
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();

  /// Loading state to show progress indicator during signup
  bool _isLoading = false;

  /// Controls password visibility toggle
  bool _obscure = true;

  /// FBLA brand color used throughout the UI
  static const fblaNavy = Color(0xFF0A2E7F);

  @override
  void dispose() {
    // Clean up text controllers to prevent memory leaks
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  /// Displays a dialog with a title and message
  /// @param title The dialog title
  /// @param message The dialog message content
  /// @param success If true, navigates to login page after closing dialog
  void _showDialog(String title, String message, {bool success = false}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
            color: fblaNavy,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Navigate to login page on successful signup
              if (success) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login/', (_) => false);
              }
            },
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  /// Handles the signup process for both students and advisors
  /// @param isStudent True for student signup, false for advisor signup request
  Future<void> _signup(bool isStudent) async {
    // Validate form before proceeding
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Trim whitespace from inputs
    final fName = _firstName.text.trim();
    final lName = _lastName.text.trim();
    final email = _email.text.trim();
    final password = _password.text;

    try {
      if (isStudent) {
        // Create student account directly with Firebase Auth
        final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Set display name for the user
        await user.user!.updateDisplayName("$fName $lName");

        // Store student data in Firestore
        await FirebaseFirestore.instance
            .collection('students')
            .doc(user.user!.uid)
            .set({'first_name': fName, 'last_name': lName, 'email': email});

        _showDialog(
          'Success!',
          'Student account created successfully!',
          success: true,
        );
      } else {
        // Submit advisor signup request for admin approval
        // Note: Password is stored temporarily for admin to create account
        await FirebaseFirestore.instance.collection('signup_advisors').add({
          'first_name': fName,
          'last_name': lName,
          'email': email,
          'password': password,
        });

        _showDialog(
          'Success!',
          'Advisor signup request submitted!',
          success: true,
        );
      }

      // Clear form fields after successful signup
      _email.clear();
      _password.clear();
      _firstName.clear();
      _lastName.clear();
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors with user-friendly messages
      String msg = switch (e.code) {
        'weak-password' => 'Password too weak.',
        'email-already-in-use' => 'Email already in use.',
        'invalid-email' => 'Invalid email format.',
        _ => 'An error occurred. Please try again.',
      };
      _showDialog('Registration Failed', msg);
    } catch (_) {
      // Handle any other unexpected errors
      _showDialog('Error', 'An unexpected error occurred.');
    } finally {
      // Reset loading state if widget is still mounted
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
                  // App logo with gradient background
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

                  // Page title
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

                  // Subtitle
                  Text(
                    'Sign up to get started',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // First and Last name input fields in a row
                  Row(
                    children: [
                      Expanded(
                        child: AuthHelpers.inputField(
                          _firstName,
                          'First Name',
                          icon: Icons.person_outline,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AuthHelpers.inputField(
                          _lastName,
                          'Last Name',
                          icon: Icons.person_outline,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email input field with validation
                  AuthHelpers.inputField(
                    _email,
                    'Email',
                    icon: Icons.email_outlined,
                    validator: (v) => v!.contains('@') ? null : 'Invalid email',
                  ),
                  const SizedBox(height: 16),

                  // Password input field with visibility toggle and validation
                  AuthHelpers.inputField(
                    _password,
                    'Password',
                    obscure: _obscure,
                    icon: Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    validator: (v) =>
                        (v!.length < 6) ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 32),

                  // Student signup button
                  AuthHelpers.button(
                    'Student Sign Up',
                    () => _signup(true),
                    loading: _isLoading,
                  ),
                  const SizedBox(height: 12),

                  // Advisor signup button (secondary style)
                  AuthHelpers.button(
                    'Advisor Sign Up',
                    () => _signup(false),
                    primary: false,
                    loading: _isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Link to login page for existing users
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      TextButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login/',
                          (_) => false,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
