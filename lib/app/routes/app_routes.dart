/// App route names
abstract class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String checkin = '/attendance/checkin';
  static const String checkout = '/attendance/checkout';
  static const String attendance = '/attendance'; // General or list
  static const String history = '/history';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String leave = '/leave'; // GANAS Module
  static const String notification = '/notification';
  static const String securityViolation =
      '/security-violation'; // Security Block Screen

  // Admin routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminReports = '/admin/reports';
  static const String adminDevices = '/admin/devices';
}
