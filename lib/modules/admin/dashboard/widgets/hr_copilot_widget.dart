import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:sinergo_app/services/ai_service.dart';
import 'package:sinergo_app/modules/admin/controllers/admin_controller.dart';

import 'package:sinergo_app/app/theme/app_colors.dart';

class HrCopilotWidget extends StatefulWidget {
  const HrCopilotWidget({super.key});

  @override
  State<HrCopilotWidget> createState() => _HrCopilotWidgetState();
}

class _HrCopilotWidgetState extends State<HrCopilotWidget> {
  final AdminController controller = Get.find<AdminController>();
  final AiService _aiService = AiService();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Chat History: {role: 'user'|'ai', text: String, action: Map?}
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initial Greeting
    _messages.add({
      'role': 'ai',
      'text':
          "Halo! Saya Sinergo Copilot. Ada yang bisa saya bantu? (Misal: 'Buat pengumuman libur', 'Cek izin cuti', 'Siapa yang terlambat?')"
    });
  }

  Future<String> _gatherContextData() async {
    try {
      // 1. GATHER CONTROLLERS
      AdminController dashCtrl;
      try {
        dashCtrl = Get.find<AdminController>();
      } catch (e) {
        dashCtrl = Get.put(AdminController());
        await dashCtrl.fetchDashboardStats(forceRefresh: true);
      }

      // Ensure data is loaded
      if (dashCtrl.employees.isEmpty) await dashCtrl.fetchEmployees();
      if (dashCtrl.todaysAttendance.isEmpty &&
          dashCtrl.presentToday.value > 0) {
        await dashCtrl.fetchDashboardStats(forceRefresh: true);
      }

      // 2. GENERATE DEMO CONTEXT (FORCED LOGIC)
      String demoReport = dashCtrl.generateDemoContext();

      print("📢 DEMO CONTEXT SENT TO AI:\n$demoReport");

      // 3. BUILD JSON
      final sb = StringBuffer();
      sb.write('{');

      // Inject the ready-to-read string
      // Encode string to be safe for JSON
      sb.write('"laporan_siap_saji": ${jsonEncode(demoReport)},');

      sb.write('"statistik": {');
      sb.write('"hadir": ${dashCtrl.presentToday.value},');
      sb.write(
          '"telat": ${dashCtrl.todaysAttendance.where((a) => a.status.name == 'late' || (a.lateMinutes ?? 0) > 0).length},');
      sb.write('"total_karyawan": ${dashCtrl.totalEmployees.value}');
      sb.write('}');

      sb.write('}');

      return sb.toString();
    } catch (e) {
      print("❌ Error gathering context: $e");
      return '{"error": "Gagal mengambil data konteks: $e"}';
    }
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
      _inputController.clear();
    });
    _scrollToBottom();

    try {
      // Call AI with GATHERED CONTEXT (Await Async)
      final contextData = await _gatherContextData();
      final response = await _aiService.chatWithCopilot(text, contextData);

      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'ai',
            'text': response['text'],
            'action': response['action'] == 'NAVIGATE' ? response : null,
          });
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'ai',
            'text': "Maaf, terjadi kesalahan: $e",
            'action': null, // Ensure action is null on error
          });
          _isLoading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleAction(Map<String, dynamic> actionData) {
    if (actionData['target_route'] != null) {
      Get.toNamed(actionData['target_route'], arguments: {
        'prefill': actionData['prefill_data'], // For Announcement
        'auto_filter': 'pending' // For Approval view if needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 400, // Fixed height for chat window
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.tertiary, // Use a distinct color for header
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(5.5)),
              border: const Border(
                  bottom: BorderSide(color: Colors.black, width: 2.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.black),
                const SizedBox(width: 8),
                const Text("Sinergo Actionable Copilot",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        fontSize: 16)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.black),
                  onPressed: () {
                    // Optional: Minimize or clear chat
                  },
                )
              ],
            ),
          ),

          // Chat List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                final hasAction = msg['action'] != null;

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? AppColors.primary : Colors.white,
                            border: Border.all(color: Colors.black, width: 2.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 0,
                                offset: Offset(2, 2),
                              )
                            ],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(8),
                              topRight: const Radius.circular(8),
                              bottomLeft: isUser
                                  ? const Radius.circular(8)
                                  : Radius.zero,
                              bottomRight: isUser
                                  ? Radius.zero
                                  : const Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            msg['text'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (hasAction)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ActionChip(
                              avatar: const Icon(Icons.rocket_launch,
                                  size: 16, color: Colors.black),
                              label: Text(
                                  // Use dynamic label from AI or fallback
                                  msg['action']['button_label'] ?? "Buka Menu",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              backgroundColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    color: Colors.black, width: 2.5),
                              ),
                              onPressed: () => _handleAction(msg['action']),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                minHeight: 4,
                color: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),

          // Input Area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "Ketik perintah...",
                        hintStyle: const TextStyle(color: Colors.black54),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.5),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16)),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurRadius: 0)
                      ]),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
