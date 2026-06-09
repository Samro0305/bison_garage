import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice_model.dart';
import 'invoice_provider.dart';

class MonthlySummary {
  final int invoiceCount;
  final double revenue;
  final double gst;
  final double averageInvoice;

  const MonthlySummary({
    required this.invoiceCount,
    required this.revenue,
    required this.gst,
    required this.averageInvoice,
  });
}

final monthlySummaryProvider =
    Provider<MonthlySummary>((ref) {
  final List<InvoiceModel> invoices =
      ref.watch(invoiceProvider);

  final now = DateTime.now();

  final monthlyInvoices = invoices.where(
    (invoice) =>
        invoice.createdAt.month ==
            now.month &&
        invoice.createdAt.year ==
            now.year,
  );

  final invoiceCount =
      monthlyInvoices.length;

  final revenue = monthlyInvoices.fold(
    0.0,
    (sum, invoice) =>
        sum + invoice.grandTotal,
  );

  final gst = monthlyInvoices.fold(
    0.0,
    (sum, invoice) =>
        sum + invoice.gstAmount,
  );

  final double averageInvoice =
      invoiceCount == 0
          ? 0.0
          : revenue / invoiceCount;

  return MonthlySummary(
    invoiceCount: invoiceCount,
    revenue: revenue,
    gst: gst,
    averageInvoice: averageInvoice,
  );
});