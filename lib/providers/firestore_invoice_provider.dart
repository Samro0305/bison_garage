import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice_model.dart';
import '../services/firestore_invoice_service.dart';

final firestoreInvoiceProvider =
    StreamProvider<List<InvoiceModel>>(
  (ref) {
    return FirestoreInvoiceService
        .getInvoicesStream();
  },
);