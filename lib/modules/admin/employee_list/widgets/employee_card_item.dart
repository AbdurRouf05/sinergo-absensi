import 'package:flutter/material.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/app/theme/app_colors.dart';

class EmployeeCardItem extends StatelessWidget {
  final UserLocal user;

  const EmployeeCardItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withAlpha(25),
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            _buildRoleBadge(user.role),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email, style: const TextStyle(color: AppColors.grey600)),
            const SizedBox(height: 4),
            _buildAccessStatus(user),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.grey400),
        onTap: () {
          // Future: Details view
        },
      ),
    );
  }

  Widget _buildRoleBadge(UserRole role) {
    Color color = AppColors.primary;
    if (role == UserRole.admin) color = Colors.red;
    if (role == UserRole.hr) color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        role.displayName,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAccessStatus(UserLocal user) {
    String status = 'Semua Kantor';
    IconData icon = Icons.public;
    Color color = Colors.green;

    if (user.allowedOfficeIds != null && user.allowedOfficeIds!.isNotEmpty) {
      if (user.allowedOfficeIds!.length == 1) {
        status = 'Kantor Tunggal';
        icon = Icons.location_on;
        color = Colors.blue;
      } else {
        status = 'Multi Kantor (${user.allowedOfficeIds!.length})';
        icon = Icons.hub;
        color = Colors.purple;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
