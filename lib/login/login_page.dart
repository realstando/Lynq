import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/login/auth_helpers.dart';

/// Login page for user authentication using Firebase Auth
/// Features email/password login with validation, error handling, and navigation to signup
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Form key for validating email and password fields
  final _formKey = GlobalKey<FormState>();

  /// Controller for email input field
  final _email = TextEditingController();

  /// Controller for password input field
  final _password = TextEditingController();

  /// Loading state indicator - shows spinner during authentication
  bool _isLoading = false;

  /// Controls password visibility toggle
  /// true = password hidden (obscured), false = password visible
  bool _obscure = true;

  /// FBLA Official Navy color for consistent branding
  static const fblaNavy = Color(0xFF0A2E7F);

  /// Clean up text controllers when widget is disposed to prevent memory leaks
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Shows a dialog with custom title and message
  /// Used for displaying error messages and notifications to the user
  ///
  /// [title] - The dialog header text
  /// [message] - The dialog body text
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        // Rounded corners for modern look
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
            color: fblaNavy,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(foregroundColor: fblaNavy),
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  /// Handles the login process with Firebase Authentication
  /// Validates form, attempts sign in, and navigates on success
  /// Shows appropriate error messages for different failure scenarios
  Future<void> _login() async {
    // Validate form fields before attempting login
    if (!_formKey.currentState!.validate()) return;

    // Show loading indicator
    setState(() => _isLoading = true);

    try {
      // Attempt to sign in with Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(), // Remove whitespace from email
        password: _password.text,
      );

      // Navigate to home page on successful login
      // Remove all previous routes from navigation stack
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home/', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific authentication errors
      // Use pattern matching to provide user-friendly error messages
      String msg = switch (e.code) {
        'user-not-found' => 'No account found with this email.',
        'wrong-password' => 'Incorrect password. Please try again.',
        'invalid-email' => 'Invalid email address.',
        'user-disabled' => 'This account has been disabled.',
        // Default message for any other Firebase auth error
        _ => 'Username or password was incorrect. Please try again.',
      };
      _showDialog('Login Failed', msg);
    } catch (_) {
      // Catch any unexpected errors not from Firebase
      _showDialog('Error', 'An unexpected error occurred.');
    } finally {
      // Always hide loading indicator when done (success or failure)
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // SafeArea ensures content doesn't overlap system UI (notch, status bar)
      body: SafeArea(
        child: Center(
          // SingleChildScrollView prevents overflow on small screens/keyboards
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Logo container with gradient background and shadow
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      // Gradient background for visual depth
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0XFF0A2E7F).withValues(alpha: 0.3),
                          Color(0XFF1D52BC).withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      // Drop shadow for elevation effect
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

                  // Welcome header text
                  const Text(
                    'Welcome to Lynq',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: fblaNavy,
                      letterSpacing: -0.5, // Tight spacing for modern look
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle text
                  Text(
                    'Sign in to continue',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email input field with validation
                  AuthHelpers.inputField(
                    _email,
                    'Email',
                    icon: Icons.email_outlined,
                    validator: (v) {
                      // Validate email is not empty and contains @ symbol
                      if (v == null || v.isEmpty)
                        return 'Please enter your email';
                      if (!v.contains('@')) return 'Invalid email address';
                      return null; // null means validation passed
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password input field with visibility toggle and validation
                  AuthHelpers.inputField(
                    _password,
                    'Password',
                    obscure: _obscure, // Hide password characters
                    icon: Icons.lock_outline,
                    // Suffix button to toggle password visibility
                    suffix: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons
                                  .visibility_outlined // Show eye icon when hidden
                            : Icons
                                  .visibility_off_outlined, // Show eye-off when visible
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    validator: (v) {
                      // Validate password is not empty and meets minimum length
                      if (v == null || v.isEmpty) return 'Enter your password';
                      if (v.length < 6) return 'Password must be 6+ characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Login button with loading state
                  AuthHelpers.button('Login', _login, loading: _isLoading),
                  const SizedBox(height: 24),

                  // Sign up link for users without an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        // Navigate to signup page, clearing navigation stack
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/signup/',
                          (_) => false,
                        ),
                        child: const Text(
                          'Sign Up',
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
