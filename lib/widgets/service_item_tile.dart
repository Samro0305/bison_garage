import 'package:flutter/material.dart';

class ServiceItemTile extends StatelessWidget {
  final TextEditingController serviceController;
  final TextEditingController amountController;
  final VoidCallback onDelete;
  final VoidCallback onAmountChanged;

  const ServiceItemTile({
    super.key,
    required this.serviceController,
    required this.amountController,
    required this.onDelete,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: serviceController,
                decoration: const InputDecoration(
                  labelText: 'Service',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                onChanged: (_) => onAmountChanged(),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
              ),
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