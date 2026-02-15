import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import 'profile_controller.dart';
import 'widgets/profile_action_section.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_section.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // If controller not found, try to find or put it (Safety for direct view)
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }

    return const Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            SizedBox(height: 20),
            ProfileInfoSection(),
            SizedBox(height: 20),
            ProfileActionSection(),
            SizedBox(height: 40),
            Text(
              "App Version 1.0.0",
              style: TextStyle(color: AppColors.grey400, fontSize: 12),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
