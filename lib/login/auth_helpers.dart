import 'package:flutter/material.dart';

class AuthHelpers {

  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);

  static Widget inputField(TextEditingController ctrl, String hint,
      {bool obscure = false, IconData? icon, String? Function(String?)? validator, Widget? suffix}) {
    return Container(
      decoration: AuthHelpers._decor(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: TextFormField(
          controller: ctrl,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: fblaNavy, size: 22),
            suffixIcon: suffix,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  static Widget button(String text, VoidCallback onTap,
      {bool loading = false, bool primary = true}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? fblaGold : Colors.white,
          foregroundColor: primary ? fblaNavy : fblaNavy,
          side: primary ? null : const BorderSide(color: fblaNavy, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(
                text,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, letterSpacing: -0.2),
              ),
      ),
    );
  }

  static BoxDecoration _decor() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      );
}