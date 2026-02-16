import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import 'package:sinergo_app/services/ai_service.dart';
import 'package:sinergo_app/modules/admin/controllers/admin_controller.dart';

class SmartInsightCard extends StatefulWidget {
  const SmartInsightCard({super.key});

  @override
  State<SmartInsightCard> createState() => _SmartInsightCardState();
}

class _SmartInsightCardState extends State<SmartInsightCard> {
  final AdminController controller = Get.find<AdminController>();
  final AiService _aiService = AiService();

  String? _insight;
  bool _isLoading = false;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    // Auto-load if data is available, but wait a bit to not block UI
    Future.delayed(const Duration(seconds: 1), _generateInsight);
  }

  Future<void> _generateInsight() async {
    if (_isLoading) return;
    if (controller.todaysAttendance.isEmpty) {
      if (mounted) {
        setState(() =>
            _insight = "Belum ada data absensi hari ini untuk dianalisa.");
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result =
          await _aiService.analyzeAttendance(controller.todaysAttendance);
      if (mounted) {
        setState(() {
          _insight = result;
          _isLoading = false;
          _hasLoaded = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _insight = "Gagal memuat analisa AI.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.indigo, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "AI HR Insight",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const Spacer(),
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20, color: Colors.grey),
                  onPressed: _generateInsight,
                  tooltip: "Refresh Analisa",
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_insight != null)
            MarkdownBody(
              data: _insight!,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 14, color: Colors.black87),
                listBullet: const TextStyle(color: Colors.indigo),
              ),
            )
          else if (!_hasLoaded)
            const Text("Menganalisa data absensi...",
                style:
                    TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
          else
            const Text("Siap menganalisa.",
                style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
