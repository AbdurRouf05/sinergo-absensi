import 'package:isar/isar.dart';

part 'daily_recap_model.g.dart';

@collection
class DailyRecapLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date; // The date of the recap (midnight)

  int totalPresent = 0; // Hadir + Telat
  int totalLeave = 0; // Approved Leave
  int totalPending = 0; // ✅ NEW: Cache Pending Requests
  int totalAbsent = 0; // ALPA (Bolos)

  // List of names of employees who are absent (ALPA)
  List<String> absentEmployeeNames = [];

  late DateTime createdAt;
  late DateTime updatedAt;
}
