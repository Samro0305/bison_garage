import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice_model.dart';
import '../services/firestore_invoice_service.dart';

class InvoiceNotifier
extends StateNotifier<List<InvoiceModel>> {
InvoiceNotifier() : super([]);

void loadInvoices() {}

Future<void> addInvoice(
InvoiceModel invoice,
) async {
await FirestoreInvoiceService
.saveInvoice(
invoice,
);
}

Future<void> updateInvoice(
InvoiceModel invoice,
) async {
await FirestoreInvoiceService
.updateInvoice(
invoice,
);
}

Future<void> deleteInvoice(
String invoiceId,
) async {
await FirestoreInvoiceService
.deleteInvoice(
invoiceId,
);
}

InvoiceModel? getInvoice(
String invoiceId,
) {
try {
return state.firstWhere(
(invoice) =>
invoice.invoiceId ==
invoiceId,
);
} catch (_) {
return null;
}
}
}

final invoiceProvider =
StateNotifierProvider<
InvoiceNotifier,
List<InvoiceModel>>(
(ref) => InvoiceNotifier(),
);