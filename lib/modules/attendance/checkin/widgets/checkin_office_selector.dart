import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/data/models/office_location_model.dart';
import 'package:sinergo_app/modules/attendance/checkin/checkin_controller.dart';

class CheckInOfficeSelector extends GetView<CheckinController> {
  const CheckInOfficeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.availableOffices.isEmpty) {
        return const Text('Tidak ada lokasi kantor tersedia');
      }
      return DropdownButtonFormField<OfficeLocationLocal>(
        initialValue: controller.selectedOffice.value,
        decoration: const InputDecoration(
          labelText: 'Lokasi Presensi',
          border: OutlineInputBorder(),
        ),
        items: controller.availableOffices.map((office) {
          return DropdownMenuItem(
            value: office,
            child: Text(office.name),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) controller.selectedOffice.value = val;
        },
      );
    });
  }
}
