import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_invoice_list_provider.dart';


final totalRevenueProvider =
    Provider<double>((ref) {
  final invoices =
      ref.watch(
        firestoreInvoiceListProvider,
      );

  return invoices.fold(
    0,
    (sum, invoice) =>
        sum + invoice.grandTotal,
  );
});

final totalGstProvider =
    Provider<double>((ref) {
  final invoices =
    ref.watch(
      firestoreInvoiceListProvider,
    );

  return invoices.fold(
    0,
    (sum, invoice) =>
        sum + invoice.gstAmount,
  );
});

final totalInvoicesProvider =
    Provider<int>((ref) {
  return ref.watch(
  firestoreInvoiceListProvider,
).length;
});

final todayRevenueProvider =
    Provider<double>((ref) {
  final invoices =
    ref.watch(
      firestoreInvoiceListProvider,
    );
  final now = DateTime.now();

  return invoices
      .where(
        (invoice) =>
            invoice.createdAt.day ==
                now.day &&
            invoice.createdAt.month ==
                now.month &&
            invoice.createdAt.year ==
                now.year,
      )
      .fold(
        0,
        (sum, invoice) =>
            sum + invoice.grandTotal,
      );
});

final monthlyRevenueProvider =
    Provider<double>((ref) {
  final invoices =
    ref.watch(
      firestoreInvoiceListProvider,
    );

  final now = DateTime.now();

  return invoices
      .where(
        (invoice) =>
            invoice.createdAt.month ==
                now.month &&
            invoice.createdAt.year ==
                now.year,
      )
      .fold(
        0,
        (sum, invoice) =>
            sum + invoice.grandTotal,
      );
});