import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/app/theme/app_colors.dart';
import 'package:attendance_fusion/core/constants/app_constants.dart';
import '../logic/office_selection_manager.dart';

class OfficeSelectorDropdown extends StatelessWidget {
  final OfficeSelectionManager selectionManager;

  const OfficeSelectorDropdown({
    super.key,
    required this.selectionManager,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final offices = selectionManager.filteredOffices;
      final selected = selectionManager.selectedOffice.value;

      if (offices.isEmpty) {
        return const Text("Tidak ada kantor tersedia",
            style: TextStyle(color: Colors.red));
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            // FIX: Use ID (String) for value, and ensure it exists in items list
            value: offices.any((o) => o.odId == selected?.odId)
                ? selected?.odId
                : null,
            isExpanded: true,
            hint: const Text("Pilih Kantor"),
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
            items: offices.map((office) {
              final isGanas = office.odId == AppConstants.officeIdGanas;
              return DropdownMenuItem<String>(
                value: office.odId,
                child: Row(
                  children: [
                    Icon(
                      isGanas ? Icons.warning_amber_rounded : Icons.location_on,
                      size: 20,
                      color: isGanas ? Colors.orange : AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        office.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isGanas ? FontWeight.bold : FontWeight.w500,
                          color: isGanas ? Colors.orange.shade800 : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (officeId) {
              if (officeId != null) {
                // Find office object by ID
                final newOffice =
                    offices.firstWhereOrNull((o) => o.odId == officeId);
                if (newOffice != null) {
                  selectionManager.selectOffice(newOffice);
                }
              }
            },
          ),
        ),
      );
    });
  }
}
