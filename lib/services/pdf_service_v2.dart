import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/garage_settings_model.dart';
import '../models/invoice_model.dart';

class PdfServiceV2 {
  static Future<void> generateAndShareInvoice(
    InvoiceModel invoice,
    GarageSettingsModel garage,
  ) async {
    final pdf = pw.Document();

    pw.MemoryImage? logoImage;
    pw.MemoryImage? signatureImage;

    if (garage.logoPath.isNotEmpty) {
      final logoFile = File(garage.logoPath);

      if (await logoFile.exists()) {
        logoImage = pw.MemoryImage(
          await logoFile.readAsBytes(),
        );
      }
    }

    if (garage.signaturePath.isNotEmpty) {
  final signatureFile =
      File(garage.signaturePath);

  if (await signatureFile.exists()) {
    signatureImage = pw.MemoryImage(
      await signatureFile.readAsBytes(),
    );
  }
}

// PAGE 1
pdf.addPage(
  pw.Page(
    pageFormat: PdfPageFormat.a4,
    build: (context) {
      return pw.Stack(
        children: [
          pw.Center(
            child: pw.Opacity(
              opacity: 0.18,
              child: pw.Text(
                'BISON\nGARAGE\nPREMIUM',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 100,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey500,
                ),
              ),
            ),
          ),

          pw.Column(
            children: [
              pw.SizedBox(height: 15),

              if (logoImage != null)
                pw.Image(
                  logoImage,
                  height: 150,
                ),

              pw.SizedBox(height: 20),

              pw.Text(
                garage.garageName,
                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Container(
                height: 3,
                width: 250,
                color: PdfColors.orange,
              ),

              pw.SizedBox(height: 20),

              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Text(
                  'TAX INVOICE',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 25),

              pw.Text('Owner : ${garage.ownerName}'),
              pw.SizedBox(height: 5),

              pw.Text('Phone : ${garage.phoneNumber}'),
              pw.SizedBox(height: 5),

              pw.Text('Address : ${garage.address}'),
              pw.SizedBox(height: 5),

              pw.Text('GST : ${garage.gstNumber}'),

              pw.SizedBox(height: 30),

              pw.Row(
                mainAxisAlignment:
                    pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Text(
                      'Invoice No : ${invoice.invoiceNumber}',
                    ),
                  ),
                  pw.Container(
                    padding:
                        const pw.EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    color: PdfColors.green,
                    child: pw.Text(
                      'PAID',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight:
                            pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 15),

              pw.Text(
                'Date : ${invoice.createdAt.day}/${invoice.createdAt.month}/${invoice.createdAt.year}',
              ),

              pw.Spacer(),

              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Text(
                  'Page 1 of 2',
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  ),
);
      

    // PAGE 2
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
  pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
    child: pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Customer : ${invoice.customerName}',
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Phone : ${invoice.customerPhone}',
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Vehicle : ${invoice.vehicleNumber}',
        ),
      ],
    ),
  ),

  pw.SizedBox(height: 20),

  pw.TableHelper.fromTextArray(
    headers: const [
      'S.No',
      'Service',
      'Amount (Rs)',
    ],
    border: pw.TableBorder.all(),
    headerDecoration:
        const pw.BoxDecoration(
      color: PdfColors.blueGrey800,
    ),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
    ),
    data: List.generate(
      invoice.services.length,
      (index) => [
        '${index + 1}',
        invoice.services[index].serviceName,
        invoice.services[index]
            .amount
            .toStringAsFixed(2),
      ],
    ),
  ),

  pw.Spacer(),

  pw.Divider(),

  pw.Text(
    'This is a computer generated invoice',
    style: const pw.TextStyle(
      fontSize: 10,
    ),
  ),

  pw.SizedBox(height: 15),

  pw.Align(
    alignment: pw.Alignment.centerRight,
    child: pw.Container(
      width: 250,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Subtotal'),
              pw.Text(
                invoice.subtotal
                    .toStringAsFixed(2),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('GST'),
              pw.Text(
                invoice.gstAmount
                    .toStringAsFixed(2),
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
                  fontWeight:
                      pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                invoice.grandTotal
                    .toStringAsFixed(2),
                style: pw.TextStyle(
                  fontWeight:
                      pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),

  pw.SizedBox(height: 20),

  pw.Center(
    child: pw.Column(
      children: [
        pw.Text(
          'Thank You For Choosing ${garage.garageName}',
          style: pw.TextStyle(
            fontWeight:
                pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(garage.phoneNumber),
        pw.Text(garage.gstNumber),
      ],
    ),
  ),

  pw.SizedBox(height: 40),

  pw.Align(
  alignment: pw.Alignment.centerRight,
  child: pw.Column(
    children: [

      if (signatureImage != null)
        pw.Image(
          signatureImage,
          height: 60,
        ),

      pw.Container(
        width: 180,
        height: 1,
        color: PdfColors.black,
      ),

      pw.SizedBox(height: 5),

      pw.Text(
        'Authorized Signature',
      ),

      pw.SizedBox(height: 20),

      pw.Align(
        alignment: pw.Alignment.bottomRight,
        child: pw.Text(
          'Page 2 of 2',
          style: const pw.TextStyle(
            fontSize: 10,
          ),
        ),
      ),
    ],
  ),
),
],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();

    final file = File(
  '${output.path}/BisonGarage_${invoice.invoiceNumber}.pdf',
);

    await file.writeAsBytes(
      await pdf.save(),
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(file.path),
        ],
      ),
    );
  }
}