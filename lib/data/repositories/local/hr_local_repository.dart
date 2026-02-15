import 'package:isar/isar.dart';
import 'package:attendance_fusion/data/models/shift_model.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/services/isar_service.dart';

class ShiftLocalRepository {
  final IsarService _isarService;

  ShiftLocalRepository(this._isarService);

  Isar get _isar => _isarService.isar;

  /// Save shift
  Future<int> saveShift(ShiftLocal shift) async {
    // 1. READ (Outside Transaction)
    final existing =
        await _isar.shiftLocals.filter().odIdEqualTo(shift.odId).findFirst();

    if (existing != null) {
      shift.id = existing.id;
    }

    // 2. WRITE (Fast)
    return await _isar.writeTxn(() async {
      return await _isar.shiftLocals.put(shift);
    });
  }

  /// Save multiple shifts (Batch Upsert)
  Future<void> saveShifts(List<ShiftLocal> shifts) async {
    if (shifts.isEmpty) return;

    // 1. BATCH READ (Outside Transaction)
    final odIds = shifts.map((header) => header.odId).toList();
    final existingShifts = await _isar.shiftLocals
        .filter()
        .anyOf(odIds, (q, String id) => q.odIdEqualTo(id))
        .findAll();

    final existingMap = {for (var s in existingShifts) s.odId: s.id};

    // 2. UPDATE IDs
    for (var shift in shifts) {
      if (existingMap.containsKey(shift.odId)) {
        shift.id = existingMap[shift.odId]!;
      }
    }

    // 3. BATCH WRITE (Fast)
    await _isar.writeTxn(() async {
      await _isar.shiftLocals.putAll(shifts);
    });
  }

  /// Get shift by ID
  Future<ShiftLocal?> getShiftById(int id) async {
    return await _isar.shiftLocals.get(id);
  }

  /// Get shift by PocketBase OdId (string)
  Future<ShiftLocal?> getShiftByOdId(String odId) async {
    return await _isar.shiftLocals.filter().odIdEqualTo(odId).findFirst();
  }

  Future<List<ShiftLocal>> getAllShifts() async {
    return await _isar.shiftLocals.where().findAll();
  }
}

class LeaveLocalRepository {
  final IsarService _isarService;

  LeaveLocalRepository(this._isarService);

  Isar get _isar => _isarService.isar;

  /// Save leave request
  Future<int> saveLeaveRequest(LeaveRequestLocal request) async {
    return await _isar.writeTxn(() async {
      return await _isar.leaveRequestLocals.put(request);
    });
  }

  /// Get leave requests for employee
  Future<List<LeaveRequestLocal>> getLeaveRequests(String userId) async {
    return await _isar.leaveRequestLocals
        .filter()
        .userIdEqualTo(userId)
        .sortByStartDateDesc()
        .findAll();
  }
}
