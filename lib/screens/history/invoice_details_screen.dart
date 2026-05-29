import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/garage_settings_model.dart';
import '../../services/settings_service.dart';
import '../../services/pdf_service.dart';
import '../../models/invoice_model.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoice,
  });

Future<void> generatePdf() async {
  final GarageSettingsModel garage =
    SettingsService.getSettings();

  await PdfService.generateAndShareInvoice(
    invoice,
    garage,
  );
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

          SizedBox(
            height: 55,
            child: ElevatedButton(
  onPressed: generatePdf,
  child: const Text(
    'GENERATE PDF',
  ),
)
          ),
        ],
      ),
    );
  }
}