import 'package:isar/isar.dart';

part 'shift_model.g.dart';

@collection
class ShiftLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String odId; // PocketBase ID

  late String name; // "Shift Pagi"
  late String startTime; // "08:00"
  late String endTime; // "17:00"
  late int graceMinutes; // 15

  // List of working days, e.g., ["senin", "selasa", ...]
  List<String> workDays = [];

  // Helper getters
  @ignore
  TimeOfDay get start {
    final sep = startTime.contains(':') ? ':' : '.';
    final parts = startTime.split(sep);
    final hour = int.tryParse(parts[0]) ?? 8;
    final minute = (parts.length > 1) ? (int.tryParse(parts[1]) ?? 0) : 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @ignore
  TimeOfDay get end {
    final sep = endTime.contains(':') ? ':' : '.';
    final parts = endTime.split(sep);
    final hour = int.tryParse(parts[0]) ?? 17;
    final minute = (parts.length > 1) ? (int.tryParse(parts[1]) ?? 0) : 0;
    return TimeOfDay(hour: hour, minute: minute);
  }
}

// Simple helper class since TimeOfDay is UI dependent usually,
// but we just keep it simple here or parse manually.
class TimeOfDay {
  final int hour;
  final int minute;
  const TimeOfDay({required this.hour, required this.minute});
}
