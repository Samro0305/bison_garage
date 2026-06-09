import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice_model.dart';
import '../services/invoice_service.dart';

class InvoiceNotifier
    extends StateNotifier<List<InvoiceModel>> {
  InvoiceNotifier() : super([]) {
    loadInvoices();
  }

  void loadInvoices() {
    state = InvoiceService.getAllInvoices();
  }

Future<void> addInvoice(
  InvoiceModel invoice,
) async {
  await InvoiceService.saveInvoice(
    invoice,
  );

  loadInvoices();
}

Future<void> updateInvoice(
  InvoiceModel invoice,
) async {
  await InvoiceService.updateInvoice(
    invoice,
  );

  loadInvoices();
}

Future<void> deleteInvoice(
  String invoiceId,
) async {
  await InvoiceService.deleteInvoice(
    invoiceId,
  );

  loadInvoices();
}

  InvoiceModel? getInvoice(
    String invoiceId,
  ) {
    try {
      return state.firstWhere(
        (invoice) =>
            invoice.invoiceId == invoiceId,
      );
    } catch (_) {
      return null;
    }
  }
}

final invoiceProvider = StateNotifierProvider<
    InvoiceNotifier,
    List<InvoiceModel>>(
  (ref) => InvoiceNotifier(),
);