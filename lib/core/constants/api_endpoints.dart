/// API endpoints for PocketBase collections
library;

class ApiEndpoints {
  ApiEndpoints._();

  // Base paths
  static const String api = '/api';
  static const String collections = '$api/collections';

  // Collections
  static const String users = '$collections/users';
  static const String attendance = '$collections/attendance';
  static const String officeLocations = '$collections/office_locations';
  static const String shifts = '$collections/shifts';
  static const String ganasTickets = '$collections/ganas_tickets';
  static const String overtimeRequests = '$collections/overtime_requests';
  static const String departments = '$collections/departments';

  // Auth endpoints
  static const String authWithPassword = '$users/auth-with-password';
  static const String authRefresh = '$users/auth-refresh';

  // Records
  static String record(String collection, String id) =>
      '$collections/$collection/records/$id';
  static String records(String collection) =>
      '$collections/$collection/records';
}
