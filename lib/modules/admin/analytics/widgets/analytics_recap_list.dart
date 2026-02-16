import 'package:flutter/material.dart';
import 'package:sinergo_app/data/models/dto/recap_row_model.dart';
import 'recap_item_card.dart';

class AnalyticsRecapList extends StatelessWidget {
  final List<RecapRowModel> recapValues;
  final VoidCallback onExport;

  const AnalyticsRecapList({
    super.key,
    required this.recapValues,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Rekap Kinerja",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: onExport,
              icon: const Icon(Icons.share, size: 16),
              label: const Text("Export"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (recapValues.isEmpty)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Tidak ada data rekap."),
          ))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recapValues.length,
            itemBuilder: (ctx, i) => RecapItemCard(row: recapValues[i]),
          ),
      ],
    );
  }
}
