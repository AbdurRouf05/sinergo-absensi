import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../services/smart_recap_service.dart';

class SmartInsightCard extends StatelessWidget {
  const SmartInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    // We assume the service is already put in Get
    // If not, we might need to put it or find it carefully
    if (!Get.isRegistered<SmartRecapService>()) {
      return const SizedBox.shrink();
    }

    final controller = Get.find<SmartRecapService>();

    return Obx(() {
      final insight = controller.currentInsight.value;

      if (insight == null || controller.isLoading.value) {
        return const SizedBox.shrink(); // Hide if no insight or loading
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: insight.isHighlight
                ? [
                    AppColors.primary.withValues(alpha: 0.1),
                    Colors.orange.withValues(alpha: 0.05)
                  ]
                : [
                    Colors.blue.shade50.withValues(alpha: 0.5),
                    Colors.white,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: insight.isHighlight
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.blue.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () =>
                controller.refreshInsight(), // Tap to refresh/cycle in future
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        insight.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Insight",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: AppColors.grey500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.auto_awesome,
                              size: 10,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          insight.message,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey800,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
