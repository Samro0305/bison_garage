import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_invoice_screen.dart';
import 'customer_history_screen.dart';
import 'package:hive/hive.dart';

import '../../core/constants/hive_boxes.dart';
import '../../models/garage_settings_model.dart';
import '../../models/invoice_model.dart';
import '../../services/pdf_service_v2.dart';
import '../../services/settings_service.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final InvoiceModel invoice;
  final int index;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoice,
    required this.index,
  });

  Future<void> generatePdf() async {
    final GarageSettingsModel garage =
        SettingsService.getSettings();

    await PdfServiceV2.generateAndShareInvoice(
      invoice,
      garage,
    );
  }

Future<void> deleteInvoice(
  BuildContext context,
) async {
  final confirmed =
      await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(
        'Delete Invoice',
      ),
      content: const Text(
        'Are you sure you want to delete this invoice?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              false,
            );
          },
          child: const Text(
            'Cancel',
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              true,
            );
          },
          child: const Text(
            'Delete',
          ),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  final box =
      Hive.box(HiveBoxes.invoicesBox);

  await box.deleteAt(index);

  if (context.mounted) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Invoice Deleted',
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer: ${invoice.customerName}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone: ${invoice.customerPhone}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vehicle: ${invoice.vehicleNumber}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${DateFormat('dd-MM-yyyy').format(invoice.createdAt)}',
                  ),
                  Text(
  'Invoice Number: ${invoice.invoiceNumber}',
),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...invoice.services.map(
            (service) => Card(
              child: ListTile(
                title: Text(
                  service.serviceName,
                ),
                trailing: Text(
                  '₹${service.amount.toStringAsFixed(2)}',
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal'),
                      Text(
                        '₹${invoice.subtotal.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GST'),
                      Text(
                        '₹${invoice.gstAmount.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Grand Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${invoice.grandTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

         const SizedBox(height: 30),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: generatePdf,
        child: const Text(
          'Generate PDF',
          textAlign: TextAlign.center,
        ),
      ),
    ),

    const SizedBox(width: 12),

    SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditInvoiceScreen(
                invoice: invoice,
              ),
            ),
          );

          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        child: const Text(
          'Edit Invoice',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ],
),

const SizedBox(height: 12),

Center(
  child: SizedBox(
    width: 220,
    height: 50,
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerHistoryScreen(
              customerName: invoice.customerName,
            ),
          ),
        );
      },
      child: const Text(
        'Customer History',
      ),
    ),
  ),
),

const SizedBox(height: 12),

Center(
  child: SizedBox(
    width: 220,
    height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      onPressed: () => deleteInvoice(context),
      child: const Text(
        'Delete Invoice',
      ),
    ),
  ),
),

        ],
      ),
    );
  }
}