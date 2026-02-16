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
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: insight.isHighlight ? AppColors.bgLight : Colors.white,
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () =>
                controller.refreshInsight(), // Tap to refresh/cycle in future
            borderRadius: BorderRadius.circular(8),
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
                      border: Border.all(color: Colors.black, width: 2),
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
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.auto_awesome,
                              size: 10,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          insight.message,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
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
