import 'package:flutter/material.dart';
import '../../../../data/models/attendance_model.dart';
import '../../../../app/theme/app_colors.dart';

class SyncStatusBadge extends StatelessWidget {
  final AttendanceLocal record;

  const SyncStatusBadge({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String text;
    Color color;

    if (record.isSynced) {
      icon = Icons.cloud_done;
      text = 'Tersinkronisasi';
      color = AppColors.success;
    } else if (record.isOfflineEntry) {
      icon = Icons.cloud_off;
      text = 'Dibuat Offline';
      color = AppColors.warning;
    } else {
      icon = Icons.cloud_upload_outlined;
      text = 'Menunggu Sinkronisasi';
      color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
