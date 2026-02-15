import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/isar_service.dart';

import '../../modules/leave/logic/leave_sync_manager.dart';

abstract class ILeaveRepository {
  Future<void> submitLeaveRequest(
    LeaveRequestLocal request, {
    File? attachment,
  });
  Future<List<LeaveRequestLocal>> getHistory();
  Future<void> updateLeaveStatus(String id, String status,
      {String? rejectionReason});
  Future<void> syncLeaves(String userId);
}

class LeaveRepository implements ILeaveRepository {
  final Logger _logger = Logger();
  final IIsarService _isarService = Get.find<IIsarService>();
  final IAuthService _authService = Get.find<IAuthService>();
  late final LeaveSyncManager _syncManager;

  LeaveRepository() {
    _syncManager = LeaveSyncManager(_isarService, _authService);
  }

  @override
  Future<void> submitLeaveRequest(
    LeaveRequestLocal request, {
    File? attachment,
  }) async {
    _logger.i('Submitting leave request: ${request.type}');

    try {
      request.isSynced = false;
      await _isarService.saveLeaveRequest(request);

      final pb = _authService.pb;
      final body = request.toFieldMap();

      final currentUserId = pb.authStore.record?.id;
      if (currentUserId != null) {
        body['user_id'] = currentUserId;
      }

      List<http.MultipartFile> files = [];
      if (attachment != null && await attachment.exists()) {
        files.add(
            await http.MultipartFile.fromPath('attachment', attachment.path));
      }

      final record = await pb.collection('leave_requests').create(
            body: body,
            files: files,
          );

      request.attachment = record.data['attachment'] as String?;
      request.isSynced = true;
      await _isarService.saveLeaveRequest(request);

      _logger.i('Leave request synced successfully: ${record.id}');
    } on ClientException catch (pbError) {
      _logger.w('PB Error: ${pbError.response}. Saved locally.');
    } catch (e) {
      _logger.w('Offline mode: Saved locally. Error: $e');
    }
  }

  @override
  Future<List<LeaveRequestLocal>> getHistory() async {
    final user = _authService.currentUser.value;
    if (user == null) return [];
    return await _isarService.getLeaveRequests(user.odId);
  }

  @override
  Future<void> updateLeaveStatus(String id, String status,
      {String? rejectionReason}) async {
    try {
      final body = <String, dynamic>{'status': status};
      if (rejectionReason != null) {
        body['rejection_reason'] = rejectionReason;
      }
      await _authService.pb.collection('leave_requests').update(id, body: body);
    } catch (e) {
      _logger.e('Failed to update leave status: $id', error: e);
      rethrow;
    }
  }

  @override
  Future<void> syncLeaves(String userId) async {
    await _syncManager.syncLeaves(userId);
  }
}
