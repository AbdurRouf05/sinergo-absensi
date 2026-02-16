import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/services/auth_service.dart';

class ProfileDataManager {
  final Logger _logger = Logger();
  final IAuthService _authService;

  ProfileDataManager(this._authService);

  Future<Map<String, String>> fetchProfileDetails(UserLocal? user) async {
    final result = {'shift': 'Loading...', 'office': 'Loading...'};

    try {
      if (user == null) return {'shift': '-', 'office': '-'};

      // Force fetch from PocketBase to get fresh Shift & Office info
      final pb = _authService.pb;
      final record = await pb.collection('users').getOne(
            user.odId,
            expand: 'shift, office_id',
          );

      // 1. Parse Shift
      var shifts = record.get<List<RecordModel>>('expand.shift');
      if (shifts.isEmpty) {
        shifts =
            record.get<List<RecordModel>>('expand.assigned_shift'); // Fallback
      }

      if (shifts.isNotEmpty) {
        final sData = shifts.first.data;
        result['shift'] =
            "${sData['name']} (${sData['start_time']} - ${sData['end_time']})";
      } else {
        result['shift'] = "Non-Shift";
      }

      // 2. Parse Office
      // Try 'office_id' first (standard), then 'office' (legacy), then 'assigned...' (very old)
      var offices = record.get<List<RecordModel>>('expand.office_id');
      if (offices.isEmpty) {
        offices = record.get<List<RecordModel>>('expand.office');
      }
      if (offices.isEmpty) {
        offices =
            record.get<List<RecordModel>>('expand.assigned_office_location');
      }

      if (offices.isNotEmpty) {
        final firstOffice = offices.first;
        result['office'] = firstOffice.data['name'] ?? 'Kantor Pusat';
      } else {
        result['office'] = "Belum Diatur";
      }
    } catch (e) {
      _logger.e('Profile Fetch Error', error: e);
      result['shift'] = "Gagal memuat";
      result['office'] = "Gagal memuat";
    }
    return result;
  }
}
