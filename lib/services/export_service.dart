import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:intl/intl.dart';
import 'package:attendance_fusion/data/models/dto/recap_row_model.dart';
import 'package:get/get.dart';

class ExportService {
  /// Generate and Share PDF Recap
  Future<void> exportPdfRecap({
    required List<RecapRowModel> data,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final periodStr =
        "${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}";

    // Load Logo
    final logoImage =
        await imageFromAssetBundle('assets/images/fusion_logo.png');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(logoImage, periodStr),
            pw.SizedBox(height: 20),
            _buildTable(data),
            pw.SizedBox(height: 20),
            _buildFooter(),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    final fileName =
        "Laporan_Presensi_${DateFormat('yyyyMMdd').format(startDate)}.pdf";
    await _saveAndShareFile(fileName, bytes, 'application/pdf');
  }

  /// Generate and Share CSV Recap
  Future<void> exportCsvRecap({
    required List<RecapRowModel> data,
    required DateTime startDate,
  }) async {
    final header = [
      'No',
      'Nama Karyawan',
      'Hadir (Hari)',
      'Telat (Kali)',
      'Telat (Menit)',
      'Izin (Hari)',
      'Lembur (Kali)',
      'Lembur (Menit)',
      'Alpha (Hari)',
    ];

    final rows = data.asMap().entries.map((entry) {
      final i = entry.key + 1;
      final row = entry.value;
      return [
        i,
        row.employeeName,
        row.totalPresent,
        row.totalLateCount,
        row.totalLateMinutes,
        row.totalLeave,
        row.totalOvertimeCount,
        row.totalOvertimeMinutes,
        row.totalAlpha,
      ];
    }).toList();

    final csvData = [header, ...rows];
    final csvString = _toCsv(csvData);
    final bytes = csvString.codeUnits;

    final fileName =
        "Rekap_Presensi_${DateFormat('yyyyMMdd').format(startDate)}.csv";
    await _saveAndShareFile(fileName, bytes, 'text/csv');
  }

  String _toCsv(List<List<dynamic>> rows) {
    return rows.map((row) {
      return row.map((cell) {
        String cellStr = cell.toString();
        if (cellStr.contains(',') ||
            cellStr.contains('"') ||
            cellStr.contains('\n')) {
          cellStr = '"${cellStr.replaceAll('"', '""')}"';
        }
        return cellStr;
      }).join(',');
    }).join('\n');
  }

  pw.Widget _buildHeader(pw.ImageProvider logo, String period) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("LAPORAN KINERJA KARYAWAN",
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text("Periode: $period",
                style: const pw.TextStyle(fontSize: 12)),
          ],
        ),
        pw.Container(
          height: 50,
          width: 50,
          child: pw.Image(logo),
        ),
      ],
    );
  }

  pw.Widget _buildTable(List<RecapRowModel> data) {
    return pw.TableHelper.fromTextArray(
      headers: ['No', 'Nama', 'Hadir', 'Telat', 'Izin', 'Lembur', 'Alpha'],
      data: data.asMap().entries.map((entry) {
        final i = entry.key + 1;
        final row = entry.value;
        return [
          i.toString(),
          row.employeeName,
          row.totalPresent.toString(),
          "${row.totalLateCount}x (${row.totalLateMinutes}m)",
          row.totalLeave.toString(),
          "${row.totalOvertimeCount}x (${row.totalOvertimeMinutes}m)",
          row.totalAlpha.toString(),
        ];
      }).toList(),
      headerStyle:
          pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: {
        0: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
      },
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(color: PdfColors.grey),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text("Dicetak otomatis oleh Sistem ATTENDANCE FUSION",
              style:
                  const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          pw.Text(DateFormat('dd MMM yyyy HH:mm').format(DateTime.now()),
              style:
                  const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        ])
      ],
    );
  }

  Future<void> _saveAndShareFile(
      String fileName, List<int> bytes, String mimeType) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(file.path, mimeType: mimeType)],
        text: 'Berikut adalah file rekap kinerja karyawan.',
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal export file: $e");
    }
  }
}
