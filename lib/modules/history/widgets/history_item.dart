import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/attendance_model.dart';
import '../../../../app/theme/app_colors.dart';

class HistoryItem extends StatelessWidget {
  final AttendanceLocal record;

  const HistoryItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri: Tanggal & Badge Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d MMM yyyy', 'id_ID').format(record.checkInTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.grey900,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        _getStatusColor(record.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: _getStatusColor(record.status), width: 1.5),
                  ),
                  child: Text(
                    record.status.displayName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(record.status),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Kanan: Jam Masuk & Pulang + Sync Icon
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildTimeRow(
                    'Masuk',
                    DateFormat('HH:mm').format(record.checkInTime),
                    AppColors.success,
                  ),
                  const SizedBox(height: 4),
                  _buildTimeRow(
                    'Pulang',
                    record.checkOutTime != null
                        ? DateFormat('HH:mm').format(record.checkOutTime!)
                        : '--:--',
                    record.checkOutTime != null
                        ? AppColors.error
                        : AppColors.grey400,
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Sync Indicator
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    record.isSynced ? Icons.cloud_done : Icons.cloud_off,
                    color: record.isSynced ? AppColors.primary : Colors.orange,
                    size: 20,
                  ),
                  if (!record.isSynced)
                    const Text(
                      "Local",
                      style: TextStyle(fontSize: 8, color: Colors.orange),
                    )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, String time, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, color: AppColors.grey500),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.success;
      case AttendanceStatus.late:
        return AppColors.warning;
      case AttendanceStatus.absent:
        return AppColors.error;
      case AttendanceStatus.leave:
        return AppColors.info;
      case AttendanceStatus.halfDay:
        return AppColors.warning;
      case AttendanceStatus.pendingReview:
        return Colors.orange.shade800;
    }
  }
}
