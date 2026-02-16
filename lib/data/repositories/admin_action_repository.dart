import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:isar/isar.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';

class AdminActionRepository {
  final IAuthService _auth = Get.find<IAuthService>();
  final IIsarService _isar = Get.find<IIsarService>();

  Future<void> broadcastAnnouncement({
    required String title,
    required String message,
    String target = 'all',
  }) async {
    // 1. Create locally for history (Optional, maybe an announcement collection later)
    // For now, we push to PocketBase via SyncQueue or Direct if online.
    // Let's assume Direct for Admin actions usually, but to be consistent with architecture:

    // Direct PB Call for immediate effect
    await _auth.pb.collection('notifications').create(body: {
      'title': title,
      'message': message,
      'target_users': target, // 'all' or specific ID logic
      'is_read': false,
      'created_by': _auth.currentUser.value?.id,
    });

    // In a real offline-first app, we'd queue this.
    // Keeping it simple for the restore: Direct API call.
  }

  Future<void> updateEmployeeAllowedOffices(
      String userId, List<String> officeIds) async {
    // 1. Update Remote
    await _auth.pb.collection('users').update(userId, body: {
      'office_id': officeIds,
    });

    // 2. Update Local if user exists
    final user =
        await _isar.isar.userLocals.where().odIdEqualTo(userId).findFirst();
    if (user != null) {
      await _isar.isar.writeTxn(() async {
        user.allowedOfficeIds = officeIds;
        await _isar.isar.userLocals.put(user);
      });
    }
  }

  Future<void> updateLeaveStatus(String id, String status,
      {String? rejectionReason}) async {
    // VALIDATION: Prevent 404 from empty/null ID
    if (id.isEmpty) {
      throw Exception('Cannot update leave: Remote ID (odId) is empty.');
    }

    debugPrint('📋 Updating leave request: id=$id, status=$status');

    // Declared outside try block for scope access in local update
    late RecordModel leaveRecord;

    try {
      // 1. Fetch Leave Record FIRST (To get reliable User ID)
      // We need to know WHO to notify. Relying on client-passed ID is risky.
      leaveRecord = await _auth.pb.collection('leave_requests').getOne(id);
      final targetUserId = leaveRecord.data['user_id']?.toString() ?? '';

      debugPrint('🔍 Found target user: $targetUserId');

      // 2. Update Remote Status
      final body = <String, dynamic>{'status': status};
      if (rejectionReason != null) {
        body['rejection_reason'] = rejectionReason;
      }

      await _auth.pb.collection('leave_requests').update(id, body: body);
      debugPrint('✅ Leave request $id updated on server');

      // 3. Create Notification (If User ID found)
      if (targetUserId.isNotEmpty) {
        try {
          // DIRECT PB CREATE: Most robust method for Admin Action
          // Ensure we use the fetched targetUserId

          await _auth.pb.collection('notifications').create(body: {
            'user_id': targetUserId, // CRITICAL FIX
            'target_user_id': targetUserId,
            'title': 'Izin ${status == 'approved' ? 'Disetujui' : 'Ditolak'}',
            'message':
                'Pengajuan izin Anda pada tanggal ${_formatDate(leaveRecord.data['start_date'])} telah ${status == 'approved' ? 'DISETUJUI' : 'DITOLAK'}. ${rejectionReason != null ? "Alasan: $rejectionReason" : ""}',
            'type': status == 'approved' ? 'success' : 'warning',
            'is_read': false,
            'created_by': _auth.currentUser.value?.id,
          });
          debugPrint('🔔 Notification sent to $targetUserId');
        } catch (e) {
          debugPrint('⚠️ Failed to send notification: $e');
        }
      } else {
        debugPrint(
            '⚠️ Notification skipped: User ID not found in leave record');
      }
    } catch (e) {
      debugPrint('❌ Failed to update leave $id: $e');
      rethrow;
    }

    // 4. Update Local (Keep existing logic)
    final leave = await _isar.isar.leaveRequestLocals
        .filter()
        .odIdEqualTo(id)
        .findFirst();

    if (leave != null) {
      await _isar.isar.writeTxn(() async {
        leave.status = status;
        if (rejectionReason != null) {
          leave.rejectionReason = rejectionReason;
        }
        await _isar.isar.leaveRequestLocals.put(leave);
      });
      debugPrint('✅ Leave request $id updated locally');
    } else {
      // FIX: Record not found locally (e.g. created by other user). Insert it.
      debugPrint('⚠️ Leave $id not found locally. Inserting new record...');
      final newLeave = LeaveRequestLocal.fromRecord(leaveRecord);
      // Ensure status is updated (incase PB record was stale when fetched, though getting one expects fresh)
      newLeave.status = status;
      if (rejectionReason != null) {
        newLeave.rejectionReason = rejectionReason;
      }
      // Ensure ID is set for Isar (auto-increment, but we rely on odId uniqueness)
      // Check again by OD_ID just to be ultra safe inside txn?
      // For now, just put.
      await _isar.isar.writeTxn(() async {
        // Double check OD_ID inside txn to prevent race condition?
        // Skipped for brevity, unlikely race here.
        await _isar.isar.leaveRequestLocals.put(newLeave);
      });
      debugPrint('✅ Leave request $id inserted locally');
    }
  }

  /// Updates attendance record on PocketBase.
  /// [extraBody] allows passing additional fields (e.g., approval flags).
  Future<void> updateAttendanceStatus(String id, String status,
      {Map<String, dynamic>? extraBody}) async {
    if (id.isEmpty) {
      throw Exception('Cannot update attendance: Remote ID (odId) is empty.');
    }

    try {
      // 1. Fetch Remote Record
      debugPrint('🔍 AdminActionRepo: Fetching attendance record for ID: $id');
      final attRecord = await _auth.pb.collection('attendances').getOne(id);
      debugPrint('✅ AdminActionRepo: Fetched record: ${attRecord.data}');

      final targetUserId = attRecord.data['user_id']?.toString() ??
          attRecord.data['employee']?.toString() ??
          '';
      debugPrint('🔍 AdminActionRepo: Target User ID: $targetUserId');

      // 2. Build update body
      final body = <String, dynamic>{'status': status};
      if (extraBody != null) {
        body.addAll(extraBody);
      }

      // 3. Update Remote
      debugPrint('🔍 AdminActionRepo: Updating with body: $body');
      await _auth.pb.collection('attendances').update(id, body: body);
      debugPrint('✅ AdminActionRepo: Remote status updated');

      // 4. Determine notification type (Overtime or Ganas)
      final isGanasReview = attRecord.data['is_ganas'] == true;
      final categoryLabel = isGanasReview ? 'Tugas Luar' : 'Lembur';
      final categoryKey = isGanasReview ? 'ganas' : 'lembur';

      // 5. Notify User
      if (targetUserId.isNotEmpty) {
        try {
          final isApproved = status == 'present';
          final notifBody = {
            'user_id': targetUserId,
            'target_user_id': targetUserId,
            'title': '$categoryLabel ${isApproved ? 'Disetujui' : 'Ditolak'}',
            'message':
                'Klaim $categoryLabel Anda pada ${_formatDate(attRecord.data['check_in_time'] ?? attRecord.get<String>('created'))} telah ${isApproved ? 'disetujui' : 'ditolak'} oleh Admin.',
            'category': categoryKey,
            'is_read': false,
          };
          debugPrint('🔍 AdminActionRepo: Creating notification: $notifBody');
          await _auth.pb.collection('notifications').create(body: notifBody);
          debugPrint('✅ AdminActionRepo: Notification sent');
        } catch (e) {
          debugPrint('⚠️ AdminActionRepo: Failed to send notification: $e');
        }
      }

      // 6. Update Local
      final localAtt = await _isar.isar.attendanceLocals
          .filter()
          .odIdEqualTo(id)
          .findFirst();
      if (localAtt != null) {
        await _isar.isar.writeTxn(() async {
          localAtt.status = status == 'present'
              ? AttendanceStatus.present
              : AttendanceStatus.absent;
          // Sync approval flags locally
          if (extraBody?['is_overtime_approved'] != null) {
            localAtt.isOvertimeApproved =
                extraBody!['is_overtime_approved'] as bool;
          }
          if (extraBody?['is_ganas_approved'] != null) {
            localAtt.isGanasApproved = extraBody!['is_ganas_approved'] as bool;
          }
          if (extraBody?['is_overtime'] != null) {
            localAtt.isOvertime = extraBody!['is_overtime'] as bool;
          }
          if (extraBody?['overtime_duration'] != null) {
            localAtt.overtimeMinutes = extraBody!['overtime_duration'] as int;
          }
          await _isar.isar.attendanceLocals.put(localAtt);
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to update attendance $id: $e');
      rethrow;
    }
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.tryParse(dateStr.toString());
      if (date == null) return dateStr.toString();
      // Format: dd MMM (e.g. 08 Feb)
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des'
      ];
      return '${date.day} ${months[date.month - 1]}';
    } catch (_) {
      return dateStr.toString();
    }
  }
}
