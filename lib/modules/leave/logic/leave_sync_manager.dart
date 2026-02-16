import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:isar/isar.dart';

class LeaveSyncManager {
  final IIsarService _isarService;
  final IAuthService _authService;

  LeaveSyncManager(this._isarService, this._authService);

  Future<void> syncLeaves(String userId) async {
    try {
      final baseUrl = _authService.pb.baseURL;
      final uri = Uri.parse(
          '$baseUrl/api/collections/leave_requests/records?sort=-created&perPage=100&skipTotal=1');

      final response = await http.get(uri);

      if (response.statusCode != 200) return;

      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> items = json['items'] ?? [];

      // Client-Side Filter
      final cleanId = userId.replaceAll('"', '').replaceAll("'", "").trim();
      final myLeaves = items.where((item) {
        final rId = item['user_id']?.toString() ?? '';
        return rId == cleanId;
      }).toList();

      // Convert to RecordModel and Save
      final records = myLeaves.map((json) => RecordModel(json)).toList();

      await _isarService.isar.writeTxn(() async {
        for (final record in records) {
          final existing = await _isarService.isar.leaveRequestLocals
              .filter()
              .odIdEqualTo(record.id)
              .findFirst();

          final newItem = LeaveRequestLocal.fromRecord(record);
          if (existing != null) {
            newItem.id = existing.id;
          }
          await _isarService.isar.leaveRequestLocals.put(newItem);
        }
      });
    } catch (e) {
      // Log error silently or via logger if available
    }
  }
}
