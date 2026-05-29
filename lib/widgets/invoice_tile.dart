import 'package:flutter/material.dart';

import '../models/invoice_model.dart';

class InvoiceTile extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const InvoiceTile({
    super.key,
    required this.invoice,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        title: Text(
          invoice.customerName,
        ),
        subtitle: Text(
          invoice.vehicleNumber,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₹${invoice.grandTotal.toStringAsFixed(0)}',
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}