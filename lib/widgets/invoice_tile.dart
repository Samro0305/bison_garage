import 'package:flutter/material.dart';

import '../models/invoice_model.dart';

class InvoiceTile extends StatelessWidget {
  final InvoiceModel invoice;
  final int index;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const InvoiceTile({
    super.key,
    required this.invoice,
    required this.index,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final invoiceNumber =
    invoice.invoiceNumber;
    

    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: ListTile(
        onTap: onTap,
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              invoice.customerName,
            ),
            Text(
              invoiceNumber,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
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

           if (onDelete != null)
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
