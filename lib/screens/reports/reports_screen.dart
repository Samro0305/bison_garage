import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/firestore_invoice_list_provider.dart';
import '../../providers/customer_analytics_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../services/monthly_report_pdf_service.dart';
import '../../services/monthly_excel_service.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

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

    final topCustomer =
        ref.watch(topCustomerProvider);

    final topCustomers =
        ref.watch(topCustomersProvider);

    final invoices =
    ref.watch(
      firestoreInvoiceListProvider,
    );



    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        reportCard(
          'Revenue Analytics',
          '₹${totalRevenue.toStringAsFixed(2)}',
          Icons.currency_rupee,
        ),

        reportCard(
          'Monthly Revenue',
          '₹${monthlyRevenue.toStringAsFixed(2)}',
          Icons.calendar_month,
        ),

        reportCard(
          'Today Revenue',
          '₹${todayRevenue.toStringAsFixed(2)}',
          Icons.today,
        ),

        reportCard(
          'GST Collected',
          '₹${totalGst.toStringAsFixed(2)}',
          Icons.receipt_long,
        ),

        reportCard(
          'Total Invoices',
          totalInvoices.toString(),
          Icons.description,
        ),

        if (topCustomer != null)
          Card(
            margin: const EdgeInsets.only(
              bottom: 16,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Top Customer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Name: ${topCustomer.customerName}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Invoices: ${topCustomer.invoiceCount}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Revenue: ₹${topCustomer.revenue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (topCustomers.isNotEmpty)
  Card(
    margin: const EdgeInsets.only(
      bottom: 16,
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Top 5 Customers',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          ...List.generate(
            topCustomers.length,
            (index) {
              final customer =
                  topCustomers[index];

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                child: Row(
                  children: [
                    Text(
                      '${index + 1}.',
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            customer
                                .customerName,
                          ),
                          Text(
                            '${customer.invoiceCount} invoices',
                          ),
                        ],
                      ),
                    ),

                    Text(
                      '₹${customer.revenue.toStringAsFixed(0)}',
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ),
  ),

const SizedBox(height: 20),

SizedBox(
  height: 55,
  child: ElevatedButton.icon(
    onPressed: () async {
      await MonthlyReportPdfService
    .generateAndShareReport(
  invoices,
);
    },
    icon: const Icon(
      Icons.picture_as_pdf,
    ),
    label: const Text(
      'GENERATE MONTHLY REPORT',
    ),
  ),
),

const SizedBox(height: 12),

SizedBox(
  height: 55,
  child: ElevatedButton.icon(
    onPressed: () async {
      await MonthlyExcelService
    .exportMonthlyExcel(
  invoices,
);
    },
    icon: const Icon(
      Icons.table_chart,
    ),
    label: const Text(
      'EXPORT EXCEL REPORT',
    ),
  ),
),

      ],
    );
  }

  Widget reportCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}