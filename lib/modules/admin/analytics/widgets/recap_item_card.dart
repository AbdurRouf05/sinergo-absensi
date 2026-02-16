import 'package:flutter/material.dart';
import 'package:sinergo_app/data/models/dto/recap_row_model.dart';
import 'package:sinergo_app/app/theme/app_colors.dart';

class RecapItemCard extends StatelessWidget {
  final RecapRowModel row;

  const RecapItemCard({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2.5),
              ),
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(row.employeeName[0],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(row.employeeName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip(
                          "Hadir: ${row.totalPresent}", AppColors.success),
                      _buildChip(
                          "Telat: ${row.totalLateCount} (${row.totalLateMinutes}m)",
                          AppColors.warning),
                      _buildChip("Izin: ${row.totalLeave}", AppColors.info),
                      _buildChip(
                          "OT: ${row.totalOvertimeCount} (${row.totalOvertimeMinutes}m)",
                          Colors.purple),
                      _buildChip("Alpha: ${row.totalAlpha}", AppColors.error),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
