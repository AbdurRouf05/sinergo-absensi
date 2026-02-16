import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      model: 'gemini-flash-latest',
      apiKey: apiKey,
    );
    _isInitialized = true;
  }

  Future<Map<String, dynamic>> chatWithCopilot(
      String query, String contextData) async {
    if (!_isInitialized) await init();
    if (!_isInitialized) {
      return {
        'text': "AI Service belum dikonfigurasi (API Key missing).",
        'action': 'NONE'
      };
    }

    try {
      final prompt = '''
You are Sinergo AI, the intelligent HR assistant.
I will provide you with 'CURRENT APP DATA' (JSON/Text). USE THIS DATA to answer questions accurately.

DATA CONTEXT: You have access to `detail_log_realtime`.


DATA ANALYSIS RULES:

I have provided you with `laporan_siap_saji` (A pre-calculated report string).

Use `laporan_siap_saji` as the ABSOLUTE TRUTH. Do not calculate anything.

Just read that list to the user when they ask about status.

If the user asks 'Siapa yang hadir' or 'Siapa yang telat' or 'Siapa bermasalah', quote the lines from `laporan_siap_saji`.


ANSWERING RULES:
1.  **Specific Questions (Who/How Many):** If user asks 'Siapa yang hadir?' or 'Siapa telat?', YOU MUST READ `detail_log_realtime` and list the names directly in the chat. DO NOT redirect.
2.  **Analysis:** If user asks for analysis, summarize the data first (e.g., 'Hari ini Admin hadir, Tes1 izin...').
3.  **Export/Download ONLY:** ONLY provide the 'Buka Menu Laporan' button if the user explicitly asks to 'Download', 'Export', 'Unduh', or 'Minta file Excel/PDF'.

If general question (e.g. 'cara memotivasi karyawan'), answer generally.

NAVIGATION RULES:
If user intent requires opening a menu, return JSON with action: NAVIGATE and target_route:

'Kelola karyawan/pegawai' -> /admin/employee

'Kelola lokasi/posko' -> /admin/posko

'Cek izin/cuti/approval/pending' -> /admin/approval

'Buat pengumuman' -> /admin/announcement/create
  - prefill_data MUST be a JSON Object: { "title": "...", "body": "..." }

'Rekap absensi/Laporan/Export/Unduh' -> /admin/rekap
  - button_label: '📂 Buka Menu Laporan'

Response Format (JSON Only):
{
"text": "Analisis data kamu... atau Jawaban kamu...",
"action": "NAVIGATE" | "NONE",
"target_route": "/admin/..." | null,
"button_label": "Label Tombol" (Custom label),
"prefill_data": { "title": "...", "body": "..." } | null
}

Context Data (JSON):
$contextData

User Query: $query
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        return {'text': "Maaf, saya tidak mengerti.", 'action': 'NONE'};
      }

      // 🛡️ JSON Parsing Guardrail
      String cleanJson =
          response.text!.replaceAll('```json', '').replaceAll('```', '').trim();

      // Fix potential trailing commas or minor JSON errors if needed (simplified here)
      return jsonDecode(cleanJson);
    } catch (e) {
      _logger.e("Gemini Error", error: e);
      return {
        'text': "Gagal memproses permintaan: ${e.toString()}",
        'action': 'NONE'
      };
    }
  }
}
