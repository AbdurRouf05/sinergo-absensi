import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../logic/overtime_manager.dart';
import '../../../../app/theme/app_colors.dart';

class OvertimeClaimDialog extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(File photo, String note) onConfirm;

  const OvertimeClaimDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State<OvertimeClaimDialog> createState() => _OvertimeClaimDialogState();
}

class _OvertimeClaimDialogState extends State<OvertimeClaimDialog> {
  final OvertimeManager manager = Get.find<OvertimeManager>();
  final TextEditingController _noteController = TextEditingController();
  bool _isShowingForm = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isShowingForm) _buildStep1() else _buildStep2(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        const Icon(Icons.timer_off_outlined, size: 60, color: Colors.orange),
        const SizedBox(height: 16),
        const Text(
          "Konfirmasi Pulang Terlambat",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          "Anda pulang lebih dari 60 menit setelah jam kerja berakhir. Apakah ini Lembur?",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey600),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onCancel,
                child: const Text("TIDAK"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => _isShowingForm = true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
                child: const Text("YA"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Obx(() => Column(
          children: [
            const Text(
              "Form Klaim Lembur",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: manager.capturedPhoto.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.file(manager.capturedPhoto.value!,
                            fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt,
                              size: 40, color: AppColors.grey500),
                          SizedBox(height: 8),
                          Text("Ambil Foto Pekerjaan",
                              style: TextStyle(color: AppColors.grey500)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              onChanged: (v) => manager.overtimeNote.value = v,
              decoration: const InputDecoration(
                hintText: "Deskripsi pekerjaan (min. 5 karakter)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: manager.isValid
                    ? () => widget.onConfirm(manager.capturedPhoto.value!,
                        manager.overtimeNote.value)
                    : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success),
                child: const Text("Kirim Klaim"),
              ),
            ),
          ],
        ));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final photo =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (photo != null) {
      manager.capturedPhoto.value = File(photo.path);
    }
  }
}
