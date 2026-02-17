import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../app/routes/app_routes.dart';
import '../history/history_view.dart';
import '../profile/profile_view.dart';
import '../notifications/notification_controller.dart';
import 'home_controller.dart';
import 'widgets/home_header_profile.dart';
import 'widgets/home_quick_actions.dart';
import 'widgets/home_today_status.dart';
import 'widgets/home_recent_attendance.dart';
import 'widgets/home_diagnostics.dart';
import 'widgets/smart_insight_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use WillPopScope to intercept back button
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentTabIndex.value != 0) {
          // If not on Home tab, switch to Home tab
          controller.changeTab(0);
          return false; // Do not exit app
        }
        return true; // Exit app if on Home tab
      },
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        appBar: controller.currentTabIndex.value == 0 ? _buildAppBar() : null,
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNav(),
        floatingActionButton: _buildFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Sinergo.id'),
      actions: [
        Obx(() {
          final notifController = Get.find<NotificationController>();
          return IconButton(
            icon: Badge(
              label: Text('${notifController.unreadCount.value}'),
              isLabelVisible: notifController.unreadCount.value > 0,
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              Get.toNamed(AppRoutes.notification);
            },
          );
        }),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    return Obx(() {
      switch (controller.currentTabIndex.value) {
        case 0:
          return _buildDashboard();
        case 1:
          return const HistoryView();
        case 2:
          return const ProfileView();
        default:
          return _buildDashboard();
      }
    });
  }

  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: controller.refreshDashboard,
      color: AppColors.primary,
      child: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        physics:
            AlwaysScrollableScrollPhysics(), // Ensure scrollable for RefreshIndicator
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeaderProfile(),
            SizedBox(height: 16),
            SmartInsightCard(),
            SizedBox(height: 16),
            HomeQuickActions(),
            SizedBox(height: 24),
            HomeTodayStatus(),
            SizedBox(height: 24),
            HomeRecentAttendance(),
            SizedBox(height: 24),
            HomeDiagnostics(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.currentTabIndex.value,
        onTap: controller.changeTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.large(
      onPressed: () {
        controller.attendanceController.onPresensiButtonPressed();
      },
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fingerprint, size: 32),
          SizedBox(height: 4),
          Text(
            'PRESENSI',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
