import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/firestore_invoice_service.dart';
import '../../providers/invoice_provider.dart';
import '../../models/invoice_model.dart';
import '../../models/service_item_model.dart';
import '../../widgets/service_item_tile.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() =>
    _BillingScreenState();
}

class _BillingScreenState
    extends ConsumerState<BillingScreen> {
  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final vehicleController = TextEditingController();

  bool gstEnabled = true;

  

  final List<TextEditingController> serviceControllers = [];
  final List<TextEditingController> amountControllers = [];

  @override
  void initState() {
    super.initState();
    addService();
  }

  void addService() {
    serviceControllers.add(TextEditingController());
    amountControllers.add(TextEditingController());

    setState(() {});
  }

  void removeService(int index) {
    serviceControllers[index].dispose();
    amountControllers[index].dispose();

    serviceControllers.removeAt(index);
    amountControllers.removeAt(index);

    setState(() {});
  }

  double get subtotal {
    double total = 0;

    for (final controller in amountControllers) {
      total += double.tryParse(controller.text) ?? 0;
    }

    return total;
  }

  double get gstAmount {
    if (!gstEnabled) return 0;

    return subtotal * 0.18;
  }

  double get grandTotal {
    return subtotal + gstAmount;
  }

  Future<void> saveInvoice() async {
  if (customerNameController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enter customer name'),
      ),
    );
    return;
  }

  final services = <ServiceItemModel>[];

  for (int i = 0; i < serviceControllers.length; i++) {
    final serviceName = serviceControllers[i].text.trim();

    final amount = double.tryParse(
          amountControllers[i].text.trim(),
        ) ??
        0;

    if (serviceName.isEmpty) continue;

    services.add(
      ServiceItemModel(
        serviceName: serviceName,
        amount: amount,
      ),
    );
  }

  final invoiceNumber =
    await FirestoreInvoiceService
        .generateNextInvoiceNumber();

final invoice = InvoiceModel(
  invoiceId: const Uuid().v4(),
  invoiceNumber: invoiceNumber,
  
    customerName: customerNameController.text.trim(),
    customerPhone: phoneController.text.trim(),
    vehicleNumber: vehicleController.text.trim(),
    services: services,
    subtotal: subtotal,
    gstAmount: gstAmount,
    grandTotal: grandTotal,
    isGstApplied: gstEnabled,
    createdAt: DateTime.now(),
  );

  await ref
    .read(invoiceProvider.notifier)
    .addInvoice(invoice);

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Invoice Saved Successfully'),
    ),
  );

  customerNameController.clear();
  phoneController.clear();
  vehicleController.clear();

  for (final controller in serviceControllers) {
    controller.dispose();
  }

  for (final controller in amountControllers) {
    controller.dispose();
  }

  serviceControllers.clear();
  amountControllers.clear();

  addService();

  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Customer Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: customerNameController,
            decoration: const InputDecoration(
              labelText: 'Customer Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: vehicleController,
            decoration: const InputDecoration(
              labelText: 'Vehicle Number',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: addService,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),

          const SizedBox(height: 12),

         ...List.generate(
  serviceControllers.length,
  (index) => ServiceItemTile(
    serviceController: serviceControllers[index],
    amountController: amountControllers[index],
    onDelete: () => removeService(index),
    onAmountChanged: () {
      setState(() {});
    },
  ),
),

          const SizedBox(height: 20),

          SwitchListTile(
            value: gstEnabled,
            title: const Text('Apply GST (18%)'),
            onChanged: (value) {
              setState(() {
                gstEnabled = value;
              });
            },
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
                      Text('₹${subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GST'),
                      Text('₹${gstAmount.toStringAsFixed(2)}'),
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
                        '₹${grandTotal.toStringAsFixed(2)}',
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

          const SizedBox(height: 20),

    Center(
  child: SizedBox(
    width: 180,
    height: 50,
    child: ElevatedButton(
      onPressed: saveInvoice,
      child: const Text(
        'SAVE INVOICE',
      ),
    ),
  ),
),
        ],
      ),
    );
  }
}