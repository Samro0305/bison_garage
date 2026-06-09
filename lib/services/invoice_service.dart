import 'package:hive/hive.dart';

import '../core/constants/hive_boxes.dart';
import '../models/invoice_model.dart';

class InvoiceService {
  static Box get _invoiceBox =>
      Hive.box(HiveBoxes.invoicesBox);

  static Future<void> saveInvoice(
    InvoiceModel invoice,
  ) async {
    await _invoiceBox.put(
      invoice.invoiceId,
      invoice.toMap(),
    );
  }


static String generateNextInvoiceNumber() {
  final invoices = getAllInvoices();

  int highestNumber = 0;

  for (final invoice in invoices) {
    final match = RegExp(
      r'INV-(\d+)',
    ).firstMatch(
      invoice.invoiceNumber,
    );

    if (match != null) {
      final number =
          int.tryParse(
            match.group(1)!,
          ) ??
          0;

      if (number > highestNumber) {
        highestNumber = number;
      }
    }
  }

  return 'INV-${(highestNumber + 1).toString().padLeft(4, '0')}';
}

  static Future<void> updateInvoice(
    InvoiceModel invoice,
  ) async {
    await _invoiceBox.put(
      invoice.invoiceId,
      invoice.toMap(),
    );
  }

  static List<InvoiceModel> getAllInvoices() {
    return _invoiceBox.values
        .map(
          (item) => InvoiceModel.fromMap(
            Map<dynamic, dynamic>.from(item),
          ),
        )
        .toList()
      ..sort(
        (a, b) =>
            b.createdAt.compareTo(a.createdAt),
      );
  }

  static Future<void> deleteInvoice(
    String invoiceId,
  ) async {
    await _invoiceBox.delete(invoiceId);
  }

  static InvoiceModel? getInvoice(
    String invoiceId,
  ) {
    final data = _invoiceBox.get(invoiceId);

    if (data == null) {
      return null;
    }

    return InvoiceModel.fromMap(
      Map<dynamic, dynamic>.from(data),
    );
  }
}