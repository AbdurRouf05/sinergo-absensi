import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attendance_fusion/app/theme/app_colors.dart';
import 'package:attendance_fusion/data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationLocal item;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : Colors.blue.withAlpha(12),
          border: const Border(
            bottom: BorderSide(color: AppColors.grey200),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(item.type),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontWeight:
                              item.isRead ? FontWeight.normal : FontWeight.bold,
                          color: AppColors.grey900,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM HH:mm').format(item.createdAt),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.grey400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 2),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'success':
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case 'warning':
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      case 'error':
        icon = Icons.error_outline;
        color = Colors.red;
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
