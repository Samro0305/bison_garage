import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/invoice_model.dart';

class MonthlyCsvService {
  static Future<void> exportMonthlyCsv(
    List<InvoiceModel> invoices,
  ) async {
    final StringBuffer csv = StringBuffer();

    csv.writeln(
      'Date,Customer,Phone,Vehicle,GST,Grand Total',
    );

    for (final invoice in invoices) {
      csv.writeln(
        '${invoice.createdAt.day}-${invoice.createdAt.month}-${invoice.createdAt.year},'
        '${invoice.customerName},'
        '${invoice.customerPhone},'
        '${invoice.vehicleNumber},'
        '${invoice.gstAmount.toStringAsFixed(2)},'
        '${invoice.grandTotal.toStringAsFixed(2)}',
      );
    }

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
  '${directory.path}/monthly_report.csv',
);

await file.writeAsString(
  csv.toString(),
);

    await SharePlus.instance.share(
  ShareParams(
    files: [
      XFile(file.path),
    ],
    text: 'Monthly CSV Report',
  ),
);
  }
}