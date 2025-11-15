import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupFormat extends StatelessWidget {
  final Map<String, dynamic> group;

  // FBLA Colors
  static const Color fblaBlue = Color(0xFF1D52BC);
  static const Color fblaGold = Color(0xFFF4AB19);

  const GroupFormat(this.group, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: fblaBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fblaBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Navigate to group details page
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Logo instead of group icon
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: fblaBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Image(
                      image: AssetImage('assets/Lynq_Logo.png'),
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // Group Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: fblaBlue,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.key,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Code: ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            group['code'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: fblaBlue,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Copy Button
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: group['code']));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text('Code copied: ${group['code']}'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.copy,
                    color: fblaGold,
                    size: 22,
                  ),
                  tooltip: 'Copy join code',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
