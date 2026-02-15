import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:attendance_fusion/core/constants/app_constants.dart';

class AnalyticsEmployeeRow extends StatelessWidget {
  final dynamic emp; // Ideally use strong type MonthlyStatsDTO

  const AnalyticsEmployeeRow({super.key, required this.emp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
              image: emp.avatarUrl != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(
                          "${AppConstants.pocketBaseUrl}/api/files/users/${emp.avatarUrl}"),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: emp.avatarUrl == null
                ? Center(
                    child: Text(emp.employeeName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold)))
                : null,
          ),
          const SizedBox(width: 12),

          // Name & Role
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.employeeName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(emp.jobTitle,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),

          // Stats Columns
          // Layout: H | T | I | A
          _buildStatColumn("H", emp.totalPresent, Colors.green),
          _buildStatColumn("T", emp.totalLateMinutes, Colors.orange,
              isTime: true),
          _buildStatColumn("I", emp.totalLeave, Colors.blue),
          _buildStatColumn("A", emp.totalAbsent, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, int value, Color color,
      {bool isTime = false}) {
    return SizedBox(
      width: 45, // Fixed width for alignment
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(
              isTime
                  ? (value > 999 ? "999+" : value.toString())
                  : value.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: value > 0 ? color : Colors.grey.shade400)),
        ],
      ),
    );
  }
}
