import 'package:flutter/material.dart';

/// Helper class containing reusable UI components for authentication screens
/// Provides consistent styling for input fields and buttons across login/signup pages
class AuthHelpers {
  // FBLA brand colors used throughout authentication UI
  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);

  /// Creates a styled text input field with optional icon, validation, and suffix widget
  ///
  /// Parameters:
  /// - [ctrl]: TextEditingController to manage the input field's text
  /// - [hint]: Placeholder text shown when field is empty
  /// - [obscure]: If true, hides text input (for passwords). Defaults to false
  /// - [icon]: Optional icon displayed on the left side of the field
  /// - [validator]: Optional validation function for form validation
  /// - [suffix]: Optional widget displayed on the right side (e.g., visibility toggle)
  ///
  /// Returns a styled Container with TextFormField inside
  static Widget inputField(
    TextEditingController ctrl,
    String hint, {
    bool obscure = false,
    IconData? icon,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return Container(
      // Apply consistent decoration with shadow and border
      decoration: AuthHelpers._decor(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: TextFormField(
          controller: ctrl,
          obscureText: obscure, // Hide text for password fields
          validator: validator, // Custom validation logic
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: fblaNavy,
              size: 22,
            ), // Left-side icon in navy
            suffixIcon:
                suffix, // Right-side widget (e.g., show/hide password button)
            border: InputBorder
                .none, // Remove default border (using container border instead)
          ),
        ),
      ),
    );
  }

  /// Creates a styled button with loading state support
  ///
  /// Parameters:
  /// - [text]: Button label text
  /// - [onTap]: Callback function executed when button is pressed
  /// - [loading]: If true, shows loading spinner and disables button. Defaults to false
  /// - [primary]: If true, uses gold background (primary action). If false, uses white with navy border (secondary action). Defaults to true
  ///
  /// Returns a full-width ElevatedButton with consistent styling
  static Widget button(
    String text,
    VoidCallback onTap, {
    bool loading = false,
    bool primary = true,
  }) {
    return SizedBox(
      width: double.infinity, // Full width button
      height: 56, // Fixed height for consistency
      child: ElevatedButton(
        onPressed: loading ? null : onTap, // Disable button while loading
        style: ElevatedButton.styleFrom(
          // Primary button: gold background, navy text
          // Secondary button: white background, navy text and border
          backgroundColor: primary ? fblaGold : Colors.white,
          foregroundColor: primary ? fblaNavy : fblaNavy,
          side: primary ? null : const BorderSide(color: fblaNavy, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                // Show loading spinner when button is in loading state
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
      ),
    );
  }

  /// Private helper method that returns consistent BoxDecoration for input fields
  /// Creates white background with rounded corners, subtle border, and soft shadow
  static BoxDecoration _decor() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.grey.shade200), // Light gray border
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06), // Subtle shadow for depth
        blurRadius: 12,
        offset: const Offset(0, 3), // Shadow slightly below the element
      ),
    ],
  );
}
