import 'package:flutter/material.dart';

class AnalyticsSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color bg;
  final Color color;
  final IconData icon;

  const AnalyticsSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.bg,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(title,
              style:
                  TextStyle(fontSize: 12, color: color.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}
