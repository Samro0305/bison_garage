import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/invoice_model.dart';
import '../../providers/invoice_provider.dart';
import '../../widgets/invoice_tile.dart';
import 'invoice_details_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final List<InvoiceModel> invoices =
        ref.watch(invoiceProvider);

    return Scaffold(
      body: invoices.isEmpty
          ? const Center(
              child: Text(
                'No Invoices Found',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final InvoiceModel invoice =
                    invoices[index];

                return InvoiceTile(
                  invoice: invoice,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            InvoiceDetailsScreen(
                          invoice: invoice,
                        ),
                      ),
                    );
                  },
                  onDelete: () async {
                    await ref
                        .read(
                          invoiceProvider.notifier,
                        )
                        .deleteInvoice(
                          invoice.invoiceId,
                        );
                  },
                );
              },
            ),
    );
  }
}