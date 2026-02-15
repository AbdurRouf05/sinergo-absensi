import 'package:flutter/material.dart';

/// Reusable widget for displaying solution/fix steps on the Security Violation screen.
class SecuritySolutionCard extends StatelessWidget {
  final String solution;

  const SecuritySolutionCard({super.key, required this.solution});

  @override
  Widget build(BuildContext context) {
    if (solution.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber.shade800),
              const SizedBox(width: 8),
              Text(
                "LANGKAH PERBAIKAN",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            solution,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
