import 'package:isar/isar.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sinergo_app/core/constants/app_constants.dart';

part 'leave_request_model.g.dart';

@collection
class LeaveRequestLocal {
  LeaveRequestLocal(); // ✅ Explicit default constructor

  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? userId; // ✅ RENAMED from employeeId to match PocketBase

  String? type; // sakit, izin, cuti
  String? reason;
  DateTime? startDate;
  DateTime? endDate;
  String? status; // pending, approved, rejected
  String? rejectionReason;

  // Expanded field from server (not stored in Isar, runtime only)
  @ignore
  String? userName;

  String? attachment; // Path/URL di Server
  String? localAttachmentPath; // ✅ Path lokal untuk upload

  bool isSynced = false;

  @Index(type: IndexType.value)
  String? odId; // PocketBase ID

  String? get attachmentUrl {
    if (attachment == null || attachment!.isEmpty || odId == null) return null;
    return '${AppConstants.pocketBaseUrl}/api/files/leave_requests/$odId/$attachment';
  }

  /// Helper untuk konversi ke JSON (Upload Server)
  Map<String, String> toFieldMap() {
    return {
      'user_id': userId ?? '',
      'type': type ?? 'izin',
      'reason': reason ?? '',
      'start_date': startDate?.toIso8601String() ?? '',
      'end_date': endDate?.toIso8601String() ?? '',
      'status': status ?? 'pending',
    };
  }

  factory LeaveRequestLocal.fromRecord(RecordModel record) {
    return LeaveRequestLocal()
      ..odId = record.id
      ..userId = record.data['user_id']?.toString() ?? '' // ✅ Force String
      ..type = record.data['type']
      ..reason = record.data['reason']
      ..startDate = DateTime.tryParse(record.data['start_date'] ?? '')
      ..endDate = DateTime.tryParse(record.data['end_date'] ?? '')
      ..status = record.data['status']
      ..attachment = record.data['attachment']
      ..isSynced = true;
  }
}
