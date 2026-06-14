import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../providers/firestore_invoice_list_provider.dart';
import 'invoice_details_screen.dart';

class CustomerHistoryScreen
    extends ConsumerWidget {
  final String customerName;

  const CustomerHistoryScreen({
    super.key,
    required this.customerName,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final allInvoices =
    ref.watch(
      firestoreInvoiceListProvider,
    );

    final customerInvoices =
        allInvoices.where(
      (invoice) =>
          invoice.customerName
              .toLowerCase() ==
          customerName.toLowerCase(),
    ).toList();

    final totalRevenue =
        customerInvoices.fold<double>(
      0,
      (sum, invoice) =>
          sum + invoice.grandTotal,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer History',
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    customerName,
                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    'Visits: ${customerInvoices.length}',
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    'Revenue: Rs. ${totalRevenue.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          const Text(
            'Invoices',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          ...customerInvoices.map(
            (invoice) => Card(
              child: ListTile(
                title: Text(
                  invoice.invoiceNumber,
                ),
                subtitle: Text(
                  invoice.vehicleNumber,
                ),
                trailing: Text(
                  'Rs. ${invoice.grandTotal.toStringAsFixed(0)}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          InvoiceDetailsScreen(
                        invoice: invoice,
                        index: 0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}