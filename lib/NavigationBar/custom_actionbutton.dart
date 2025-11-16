import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  const CustomActionButton({
    super.key,
    required this.openAddPage,
    required this.name,
    required this.icon,
  });
  final void Function() openAddPage;
  final String name;
  final IconData icon;

  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);
  @override
  Widget build(context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, right: 8),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: fblaNavy,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              openAddPage();
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: fblaGold,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
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
