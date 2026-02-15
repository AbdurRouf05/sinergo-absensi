import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/modules/attendance/checkin/widgets/checkin_camera_widget.dart';
import 'package:attendance_fusion/modules/attendance/checkin/widgets/checkin_map.dart';
import 'package:attendance_fusion/modules/attendance/checkin/widgets/office_selector_dropdown.dart';
import 'package:attendance_fusion/modules/attendance/checkin/widgets/checkin_status_card.dart';
import 'package:attendance_fusion/modules/attendance/checkin/widgets/checkin_submit_button.dart';
import 'package:attendance_fusion/modules/attendance/checkin/widgets/checkin_time_display.dart';

import 'checkin_controller.dart';

class CheckinView extends GetView<CheckinController> {
  const CheckinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.isCheckout.value
                  ? 'Presensi Pulang'
                  : 'Presensi Masuk',
            )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => controller.syncData(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. MAP LAYER
          const CheckInMap(),

          // 2. TOP STATUS BAR
          const Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                CheckInStatusCard(),
                SizedBox(height: 8),
                CheckInTimeDisplay(),
              ],
            ),
          ),

          // 3. BOTTOM PANEL
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OfficeSelectorDropdown(selectionManager: controller.selectionManager),
          Obx(() {
            if (!controller.ganasManager.isGanasActive.value) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  onChanged: (v) =>
                      controller.ganasManager.ganasNotes.value = v,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Tugas Luar',
                    hintText: 'Misal: Perbaikan server di PT X',
                    prefixIcon: const Icon(Icons.note_alt_rounded,
                        color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.orange, width: 2),
                    ),
                  ),
                  maxLines: 2,
                ),
              ],
            );
          }),
          const SizedBox(height: 16),
          const CheckInCameraWidget(),
          const SizedBox(height: 20),
          const CheckInSubmitButton(),
        ],
      ),
    );
  }
}
