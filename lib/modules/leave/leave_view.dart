import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'leave_controller.dart';
import 'views/leave_form_view.dart';

class LeaveView extends GetView<LeaveController> {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Izin"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: const LeaveFormView(),
    );
  }
}
