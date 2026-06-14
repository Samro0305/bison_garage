import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice_model.dart';
import 'firestore_invoice_provider.dart';

final firestoreInvoiceListProvider =
    Provider<List<InvoiceModel>>((ref) {
  final invoicesAsync =
      ref.watch(firestoreInvoiceProvider);

  return invoicesAsync.maybeWhen(
    data: (invoices) => invoices,
    orElse: () => [],
  );
});