import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice_model.dart';
import 'invoice_provider.dart';

class CustomerAnalytics {
  final String customerName;
  final double revenue;
  final int invoiceCount;

  const CustomerAnalytics({
    required this.customerName,
    required this.revenue,
    required this.invoiceCount,
  });
}

final topCustomerProvider =
    Provider<CustomerAnalytics?>((ref) {
  final List<InvoiceModel> invoices =
      ref.watch(invoiceProvider);

  if (invoices.isEmpty) {
    return null;
  }

  final Map<String, CustomerAnalytics> customers =
      {};

  for (final invoice in invoices) {
    final String name =
        invoice.customerName.trim();

    if (name.isEmpty) continue;

    if (customers.containsKey(name)) {
      final existing =
          customers[name]!;

      customers[name] =
          CustomerAnalytics(
        customerName: name,
        revenue:
            existing.revenue +
                invoice.grandTotal,
        invoiceCount:
            existing.invoiceCount + 1,
      );
    } else {
      customers[name] =
          CustomerAnalytics(
        customerName: name,
        revenue:
            invoice.grandTotal,
        invoiceCount: 1,
      );
    }
  }

  final List<CustomerAnalytics> sorted =
      customers.values.toList()
        ..sort(
          (a, b) =>
              b.revenue.compareTo(
            a.revenue,
          ),
        );

  return sorted.isEmpty
      ? null
      : sorted.first;
});

final topCustomersProvider =
    Provider<List<CustomerAnalytics>>((ref) {
  final List<InvoiceModel> invoices =
      ref.watch(invoiceProvider);

  final Map<String, CustomerAnalytics> customers =
      {};

  for (final invoice in invoices) {
    final String name =
        invoice.customerName.trim();

    if (name.isEmpty) continue;

    if (customers.containsKey(name)) {
      final existing =
          customers[name]!;

      customers[name] =
          CustomerAnalytics(
        customerName: name,
        revenue:
            existing.revenue +
                invoice.grandTotal,
        invoiceCount:
            existing.invoiceCount + 1,
      );
    } else {
      customers[name] =
          CustomerAnalytics(
        customerName: name,
        revenue:
            invoice.grandTotal,
        invoiceCount: 1,
      );
    }
  }

  final List<CustomerAnalytics> sorted =
      customers.values.toList()
        ..sort(
          (a, b) =>
              b.revenue.compareTo(
            a.revenue,
          ),
        );

  return sorted.take(5).toList();
});

final averageInvoiceValueProvider =
    Provider<double>((ref) {
  final invoices =
      ref.watch(invoiceProvider);

  if (invoices.isEmpty) {
    return 0;
  }

  final total =
      invoices.fold<double>(
    0,
    (sum, invoice) =>
        sum + invoice.grandTotal,
  );

  return total / invoices.length;
});

final highestInvoiceProvider =
    Provider<InvoiceModel?>((ref) {
  final invoices =
      ref.watch(invoiceProvider);

  if (invoices.isEmpty) {
    return null;
  }

  final sorted =
      [...invoices]
        ..sort(
          (a, b) => b.grandTotal
              .compareTo(
            a.grandTotal,
          ),
        );

  return sorted.first;
});

final topVehicleProvider =
    Provider<String?>((ref) {
  final invoices =
      ref.watch(invoiceProvider);

  if (invoices.isEmpty) {
    return null;
  }

  final Map<String, double> vehicles =
      {};

  for (final invoice in invoices) {
    final vehicle =
        invoice.vehicleNumber.trim();

    if (vehicle.isEmpty) continue;

    vehicles.update(
      vehicle,
      (value) =>
          value + invoice.grandTotal,
      ifAbsent: () =>
          invoice.grandTotal,
    );
  }

  if (vehicles.isEmpty) {
    return null;
  }

  final sorted =
      vehicles.entries.toList()
        ..sort(
          (a, b) =>
              b.value.compareTo(
            a.value,
          ),
        );

  return sorted.first.key;
});

final totalCustomersProvider =
    Provider<int>((ref) {
  final invoices =
      ref.watch(invoiceProvider);

  final Set<String> customers = {};

  for (final invoice in invoices) {
    final name =
        invoice.customerName.trim();

    if (name.isNotEmpty) {
      customers.add(name);
    }
  }

  return customers.length;
});

final repeatCustomersProvider =
    Provider<int>((ref) {
  final invoices =
      ref.watch(invoiceProvider);

  final Map<String, int> customerCount =
      {};

  for (final invoice in invoices) {
    customerCount.update(
      invoice.customerName,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  return customerCount.values
      .where((count) => count > 1)
      .length;
});

final bestCustomerProvider =
    Provider<CustomerAnalytics?>((ref) {
  final customers =
      ref.watch(topCustomersProvider);

  if (customers.isEmpty) {
    return null;
  }

  return customers.first;
});