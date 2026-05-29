import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/garage_settings_model.dart';
import '../models/invoice_model.dart';

class PdfService {
  static Future<void> generateAndShareInvoice(
    InvoiceModel invoice,
    GarageSettingsModel garage,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Center(
            child: pw.Text(
              garage.garageName,
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Text(
            'Owner: ${garage.ownerName}',
          ),

          pw.Text(
            'Phone: ${garage.phoneNumber}',
          ),

          pw.Text(
            'Address: ${garage.address}',
          ),

          pw.Text(
            'GST: ${garage.gstNumber}',
          ),

          pw.Divider(),

          pw.Text(
            'Customer: ${invoice.customerName}',
          ),

          pw.Text(
            'Phone: ${invoice.customerPhone}',
          ),

          pw.Text(
            'Vehicle: ${invoice.vehicleNumber}',
          ),

          pw.SizedBox(height: 15),

          pw.Table.fromTextArray(
            headers: const [
              'Service',
              'Amount',
            ],
            data: invoice.services
                .map(
                  (service) => [
                    service.serviceName,
                    service.amount.toStringAsFixed(2),
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Subtotal'),
              pw.Text(
                '₹${invoice.subtotal.toStringAsFixed(2)}',
              ),
            ],
          ),

          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('GST'),
              pw.Text(
                '₹${invoice.gstAmount.toStringAsFixed(2)}',
              ),
            ],
          ),

          pw.Divider(),

          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Grand Total',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '₹${invoice.grandTotal.toStringAsFixed(2)}',
              ),
            ],
          ),

          pw.SizedBox(height: 40),

          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              children: [
                pw.Container(
                  height: 50,
                ),
                pw.Text('Authorized Signature'),
              ],
            ),
          ),
        ],
      ),
    );

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/${invoice.invoiceId}.pdf',
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text: 'Garage Invoice',
    );
  }
}