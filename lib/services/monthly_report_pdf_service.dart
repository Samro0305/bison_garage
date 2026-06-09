import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/invoice_model.dart';

class MonthlyReportPdfService {
  static Future<void> generateAndShareReport(
    List<InvoiceModel> invoices,
  ) async {
    final pdf = pw.Document();

    final revenue = invoices.fold<double>(
      0,
      (sum, invoice) => sum + invoice.grandTotal,
    );

    final gst = invoices.fold<double>(
      0,
      (sum, invoice) => sum + invoice.gstAmount,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'Monthly Business Report',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),

pw.Text(
  'Generated: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
),

          pw.SizedBox(height: 20),

          pw.Text(
            'Total Invoices: ${invoices.length}',
          ),

          pw.Text(
            'Revenue: Rs ${revenue.toStringAsFixed(2)}'
          ),

          pw.Text(
            'GST Collected: Rs ${gst.toStringAsFixed(2)}'
          ),

          pw.SizedBox(height: 20),

          pw.TableHelper.fromTextArray(
  headers: const [
    'Date',
    'Customer',
    'Phone',
    'Vehicle',
    'GST',
    'Total',
  ],
  data: invoices
      .map(
        (invoice) => [
          '${invoice.createdAt.day.toString().padLeft(2, '0')}-'
              '${invoice.createdAt.month.toString().padLeft(2, '0')}-'
              '${invoice.createdAt.year}',
          invoice.customerName,
          invoice.customerPhone,
          invoice.vehicleNumber,
          invoice.gstAmount
              .toStringAsFixed(2),
          invoice.grandTotal
              .toStringAsFixed(2),
        ],
      )
      .toList(),
),
        ],
      ),
    );

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/monthly_report.pdf',
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    await SharePlus.instance.share(
  ShareParams(
    files: [
      XFile(file.path),
    ],
    text: 'Monthly Business Report',
  ),
);
  }
}