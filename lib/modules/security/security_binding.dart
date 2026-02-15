import 'package:get/get.dart';
import 'security_violation_view.dart';

class SecurityBinding extends Bindings {
  @override
  void dependencies() {
    // No specific controller needed - this is a static view
  }
}

// Route definition for app_pages.dart
final securityRoute = GetPage(
  name: '/security-violation',
  page: () => const SecurityViolationView(),
  binding: SecurityBinding(),
  transition: Transition.fade,
  transitionDuration: const Duration(milliseconds: 300),
);
