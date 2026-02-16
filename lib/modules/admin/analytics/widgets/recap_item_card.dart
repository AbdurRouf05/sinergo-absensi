import 'package:flutter/material.dart';
import 'package:sinergo_app/data/models/dto/recap_row_model.dart';
import 'package:sinergo_app/app/theme/app_colors.dart';

class RecapItemCard extends StatelessWidget {
  final RecapRowModel row;

  const RecapItemCard({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(row.employeeName[0],
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(row.employeeName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildChip("Hadir: ${row.totalPresent}", Colors.green),
                      _buildChip(
                          "Telat: ${row.totalLateCount} (${row.totalLateMinutes}m)",
                          Colors.orange),
                      _buildChip("Izin: ${row.totalLeave}", Colors.blue),
                      _buildChip(
                          "OT: ${row.totalOvertimeCount} (${row.totalOvertimeMinutes}m)",
                          Colors.purple),
                      _buildChip("Alpha: ${row.totalAlpha}", Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
