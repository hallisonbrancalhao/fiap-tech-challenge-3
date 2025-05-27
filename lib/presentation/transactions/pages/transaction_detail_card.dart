import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/configs/theme/app_theme.dart';

class TransactionDetailCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? textColor;

  const TransactionDetailCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.appTheme.primaryColor.withOpacity(0.15),
              child: Icon(
                icon,
                color: AppTheme.appTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor ?? Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
