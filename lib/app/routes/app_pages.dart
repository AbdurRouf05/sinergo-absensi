import 'package:get/get.dart';

import 'app_routes.dart';
import '../../modules/splash/splash_binding.dart';
import '../../modules/splash/splash_view.dart';
import '../../modules/auth/login/login_binding.dart';
import '../../modules/auth/login/login_view.dart';
import '../../modules/home/home_binding.dart';
import '../../modules/home/home_view.dart';
import '../../modules/attendance/checkin/checkin_binding.dart';
import '../../modules/attendance/checkin/checkin_view.dart';
import '../../modules/attendance/checkout/checkout_binding.dart';
import '../../modules/attendance/checkout/checkout_view.dart';
import '../../modules/history/history_binding.dart';
import '../../modules/history/history_view.dart';
import '../../modules/leave/leave_binding.dart';
import '../../modules/leave/leave_view.dart';
import '../../modules/security/security_binding.dart';
import '../../modules/security/security_violation_view.dart';
import '../../modules/profile/profile_binding.dart';
import '../../modules/profile/profile_view.dart';
import '../../modules/notifications/notification_binding.dart';
import '../../modules/notifications/notification_view.dart';
import '../../modules/admin/admin_binding.dart';
import '../../modules/admin/views/admin_dashboard_view.dart';
import '../../modules/admin/employee_list/employee_list_binding.dart';
import '../../modules/admin/employee_list/employee_list_view.dart';

/// App pages configuration for GetX routing
class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.checkin,
      page: () => const CheckinView(),
      binding: CheckinBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.leave,
      page: () => const LeaveView(),
      binding: LeaveBinding(),
      transition: Transition.rightToLeft,
    ),
    // Security - Block Screen (no back navigation allowed)
    GetPage(
      name: AppRoutes.securityViolation,
      page: () => const SecurityViolationView(),
      binding: SecurityBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardView(),
      binding: AdminBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.adminUsers,
      page: () => const EmployeeListView(),
      binding: EmployeeListBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
