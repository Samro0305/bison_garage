import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dashboard_provider.dart';
import '../../providers/customer_analytics_provider.dart';
import '../../providers/revenue_chart_provider.dart';
import '../../widgets/revenue_chart.dart';
import '../../providers/invoice_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final totalRevenue =
        ref.watch(totalRevenueProvider);

    final monthlyRevenue =
        ref.watch(monthlyRevenueProvider);

    final todayRevenue =
        ref.watch(todayRevenueProvider);

    final totalGst =
        ref.watch(totalGstProvider);

    final totalInvoices =
        ref.watch(totalInvoicesProvider);

    final topCustomers =
    ref.watch(topCustomersProvider);

    final bestCustomer =
    ref.watch(bestCustomerProvider);

    final totalCustomers =
    ref.watch(totalCustomersProvider);

final repeatCustomers =
    ref.watch(repeatCustomersProvider);

    final topVehicle =
    ref.watch(topVehicleProvider);

final highestInvoice =
    ref.watch(highestInvoiceProvider);

final averageInvoice =
    ref.watch(
      averageInvoiceValueProvider,
    );

    final revenueData =
    ref.watch(revenueChartProvider);

    final invoices =
    ref.watch(invoiceProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        buildCard(
          'Total Revenue',
          '₹${totalRevenue.toStringAsFixed(2)}',
        ),

        buildCard(
          'Monthly Revenue',
          '₹${monthlyRevenue.toStringAsFixed(2)}',
        ),

        buildCard(
          'Today Revenue',
          '₹${todayRevenue.toStringAsFixed(2)}',
        ),

        buildCard(
          'GST Collected',
          '₹${totalGst.toStringAsFixed(2)}',
        ),

       buildCard(
  'Total Invoices',
  totalInvoices.toString(),
),

const SizedBox(height: 16),

RevenueChart(
  data: revenueData,
),

const SizedBox(height: 16),

buildCard(
  'Top Vehicle',
  topVehicle ?? 'No Data',
),

buildCard(
  'Highest Invoice',
  highestInvoice == null
      ? '₹0'
      : '₹${highestInvoice.grandTotal.toStringAsFixed(0)}',
),

buildCard(
  'Average Invoice',
  '₹${averageInvoice.toStringAsFixed(0)}',
),

buildCard(
  'Total Customers',
  totalCustomers.toString(),
),

buildCard(
  'Repeat Customers',
  repeatCustomers.toString(),
),

buildCard(
  'Best Customer',
  bestCustomer?.customerName ??
      'No Data',
),


const SizedBox(height: 16),

Card(
  child: Padding(
    padding:
        const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Customers',
          style: TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        ...topCustomers.map(
          (customer) => Padding(
            padding:
                const EdgeInsets.only(
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text(
                  customer.customerName,
                    ),

                Text(
                    'Rs. ${customer.revenue.toStringAsFixed(0)}',
                    ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 16),

Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Invoices',
          style: TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        ...invoices
            .reversed
            .take(5)
            .map(
              (invoice) => ListTile(
                contentPadding:
                    EdgeInsets.zero,
                title: Text(
                  invoice.invoiceNumber,
                ),
                subtitle: Text(
                  invoice.customerName,
                ),
                trailing: Text(
                  '₹${invoice.grandTotal.toStringAsFixed(0)}',
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
      ],
    ),
  ),
),

      ],
    );
  }

  Widget buildCard(
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}