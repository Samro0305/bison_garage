import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/invoice_model.dart';

class MonthlyExcelService {
  static Future<void> exportMonthlyExcel(
    List<InvoiceModel> invoices,
  ) async {
    debugPrint(
      'Excel Export Count: ${invoices.length}',
    );

    final excel = Excel.createExcel();

    debugPrint(excel.tables.keys.toString());

    final sheet = excel['Monthly Report'];

    excel.setDefaultSheet(
      'Monthly Report',
    );

    try {
      excel.delete('Sheet1');
    } catch (_) {}

    sheet.appendRow([
      TextCellValue('Date'),
      TextCellValue('Customer'),
      TextCellValue('Phone'),
      TextCellValue('Vehicle'),
      TextCellValue('GST'),
      TextCellValue('Grand Total'),
    ]);

    for (final invoice in invoices) {
      sheet.appendRow([
        TextCellValue(
          '${invoice.createdAt.day.toString().padLeft(2, '0')}-'
          '${invoice.createdAt.month.toString().padLeft(2, '0')}-'
          '${invoice.createdAt.year}',
        ),
        TextCellValue(
          invoice.customerName,
        ),
        TextCellValue(
          invoice.customerPhone,
        ),
        TextCellValue(
          invoice.vehicleNumber,
        ),
        TextCellValue(
          invoice.gstAmount.toStringAsFixed(2),
        ),
        TextCellValue(
          invoice.grandTotal.toStringAsFixed(2),
        ),
      ]);
    }

    debugPrint(
      'Rows added: ${invoices.length + 1}',
    );

    final directory =
        await getApplicationDocumentsDirectory();

    final path =
        '${directory.path}/monthly_report.xlsx';

    final file = File(path);

    final bytes = excel.save();

    if (bytes == null) {
      debugPrint(
        'Excel save returned null',
      );
      return;
    }

    await file.writeAsBytes(
      bytes,
      flush: true,
    );

    debugPrint(
      'Excel file saved: ${file.path}',
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(file.path),
        ],
        text: 'Monthly Excel Report',
      ),
    );
  }
}