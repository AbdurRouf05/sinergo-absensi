import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:logger/logger.dart';

class AiService {
  final Logger _logger = Logger();
  late final GenerativeModel _model;
  bool _isInitialized = false;

  Future<void> init() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      _logger.w('GEMINI_API_KEY not found in .env');
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
    _isInitialized = true;
  }

  Future<String> analyzeAttendance(List<AttendanceLocal> logs) async {
    if (!_isInitialized) await init();
    if (!_isInitialized) {
      return "AI Service belum dikonfigurasi (API Key missing).";
    }

    try {
      // 1. Sanitize Data (Privacy First)
      // We only send timestamps and status, masking names if possible or generalized.
      // For this summary, we assume 'logs' are for the whole company or a specific filtered list.

      final sb = StringBuffer();
      sb.writeln("Data Absensi Terakhir:");
      for (var log in logs.take(20)) {
        // Limit token validation
        sb.writeln(
            "- ${log.checkInTime} | In: ${log.checkInTime} | Status: ${log.status}");
      }

      final content = [
        Content.text('''
Anda adalah Konsultan HRD Ahli untuk UMKM. Tugas Anda adalah menganalisa log absensi berikut dan memberikan insight singkat, padat, dan memotivasi dalam Bahasa Indonesia.

Tujuan: Deteksi pola keterlambatan, potensi burnout (lembur berlebihan), atau konsistensi yang baik.
Output: Gunakan Bullet points. Maksimal 3 poin utama. Tone bahasa profesional namun ramah.

Data Log:
${sb.toString()}
''')
      ];

      final response = await _model.generateContent(content);
      return response.text ?? "Tidak dapat menghasilkan analisa saat ini.";
    } catch (e) {
      _logger.e("Gemini Error", error: e);
      return "Gagal menghubungi AI Assistant. Periksa koneksi internet Anda.";
    }
  }
}
