import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/data/models/office_location_model.dart';
import 'package:sinergo_app/services/isar_service.dart';

class OfficeLocalRepository {
  final IsarService _isarService;
  final Logger _logger = Logger();

  OfficeLocalRepository(this._isarService);

  Isar get _isar => _isarService.isar;

  /// Save office location
  Future<int> saveOfficeLocation(OfficeLocationLocal location) async {
    // 1. READ (Outside Transaction)
    final existing = await _isar.officeLocationLocals
        .filter()
        .odIdEqualTo(location.odId)
        .findFirst();

    if (existing != null) {
      location.id = existing.id;
    }

    // 2. WRITE (Fast)
    return await _isar.writeTxn(() async {
      return await _isar.officeLocationLocals.put(location);
    });
  }

  /// Get all active office locations
  Future<List<OfficeLocationLocal>> getActiveOfficeLocations() async {
    return await _isar.officeLocationLocals
        .filter()
        .isActiveEqualTo(true)
        .findAll();
  }

  /// Watch active office locations (real-time updates)
  Stream<List<OfficeLocationLocal>> watchActiveOfficeLocations() {
    _logger.d('===== ISAR: Watch requested for active locations =====');
    return _isar.officeLocationLocals
        .filter()
        .isActiveEqualTo(true)
        .watch(fireImmediately: true);
  }

  /// Save office locations from sync (Upsert Pattern + Surgical Deletion)
  Future<void> saveOfficeLocations(List<OfficeLocationLocal> locations) async {
    // 1. Get all local active IDs
    final existingLocations =
        await _isar.officeLocationLocals.where().findAll();
    final serverOdIds = locations.map((e) => e.odId).toSet();

    // 2. Identify deletions (Local exists but not on server)
    final idsToDelete = existingLocations
        .where((l) => !serverOdIds.contains(l.odId))
        .map((l) => l.id)
        .toList();

    // 3. Map IDs for Upsert
    final existingMap = {for (var l in existingLocations) l.odId: l.id};
    for (var loc in locations) {
      if (existingMap.containsKey(loc.odId)) {
        loc.id = existingMap[loc.odId]!;
      }
    }

    // 4. BATCH WRITE (Fast)
    await _isar.writeTxn(() async {
      // Upsert
      if (locations.isNotEmpty) {
        await _isar.officeLocationLocals.putAll(locations);
      }
      // Surgical Delete
      if (idsToDelete.isNotEmpty) {
        await _isar.officeLocationLocals.deleteAll(idsToDelete);
      }
    });

    _logger.i(
        'Synced Office Locations: Upserted ${locations.length}, Deleted ${idsToDelete.length}');
  }

  /// Get office location by ID
  Future<OfficeLocationLocal?> getOfficeLocationByOdId(String odId) async {
    return await _isar.officeLocationLocals
        .filter()
        .odIdEqualTo(odId)
        .findFirst();
  }
}
