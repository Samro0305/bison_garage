import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_invoice_list_provider.dart';

class RevenuePoint {
  final String month;
  final double revenue;

  RevenuePoint({
    required this.month,
    required this.revenue,
  });
}

final revenueChartProvider =
    Provider<List<RevenuePoint>>((ref) {
  final invoices =
    ref.watch(
      firestoreInvoiceListProvider,
    );

  final now = DateTime.now();

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final points = <RevenuePoint>[];

  for (int i = 5; i >= 0; i--) {
    final monthDate =
        DateTime(now.year, now.month - i);

    double revenue = 0;

    for (final invoice in invoices) {
      if (invoice.createdAt.year ==
              monthDate.year &&
          invoice.createdAt.month ==
              monthDate.month) {
        revenue += invoice.grandTotal;
      }
    }

    points.add(
      RevenuePoint(
        month: months[monthDate.month - 1],
        revenue: revenue,
      ),
    );
  }

  return points;
});