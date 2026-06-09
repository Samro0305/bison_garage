import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/invoice_model.dart';
import '../../models/service_item_model.dart';
import '../../providers/invoice_provider.dart';
import '../../widgets/service_item_tile.dart';

class EditInvoiceScreen extends ConsumerStatefulWidget {
  final InvoiceModel invoice;

  const EditInvoiceScreen({
    super.key,
    required this.invoice,
  });

  @override
  ConsumerState<EditInvoiceScreen> createState() =>
      _EditInvoiceScreenState();
}

class _EditInvoiceScreenState
    extends ConsumerState<EditInvoiceScreen> {
  late TextEditingController customerNameController;
  late TextEditingController phoneController;
  late TextEditingController vehicleController;

  bool gstEnabled = true;

  final List<TextEditingController> serviceControllers = [];
  final List<TextEditingController> amountControllers = [];

  @override
  void initState() {
    super.initState();

    customerNameController =
        TextEditingController(
      text: widget.invoice.customerName,
    );

    phoneController =
        TextEditingController(
      text: widget.invoice.customerPhone,
    );

    vehicleController =
        TextEditingController(
      text: widget.invoice.vehicleNumber,
    );

    gstEnabled =
        widget.invoice.isGstApplied;

    for (final service
        in widget.invoice.services) {
      serviceControllers.add(
        TextEditingController(
          text: service.serviceName,
        ),
      );

      amountControllers.add(
        TextEditingController(
          text: service.amount.toString(),
        ),
      );
    }
  }

  double get subtotal {
    double total = 0;

    for (final controller
        in amountControllers) {
      total +=
          double.tryParse(
            controller.text,
          ) ??
          0;
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

  void addService() {
    serviceControllers.add(
      TextEditingController(),
    );

    amountControllers.add(
      TextEditingController(),
    );

    setState(() {});
  }

  void removeService(int index) {
    serviceControllers.removeAt(index);
    amountControllers.removeAt(index);

    setState(() {});
  }

  Future<void> updateInvoice() async {
    final services =
        <ServiceItemModel>[];

    for (
      int i = 0;
      i < serviceControllers.length;
      i++
    ) {
      services.add(
        ServiceItemModel(
          serviceName:
              serviceControllers[i].text,
          amount:
              double.tryParse(
                amountControllers[i].text,
              ) ??
              0,
        ),
      );
    }

    final updatedInvoice =
    InvoiceModel(
  invoiceId:
      widget.invoice.invoiceId,

  invoiceNumber:
      widget.invoice.invoiceNumber,
      customerName:
          customerNameController.text,
      customerPhone:
          phoneController.text,
      vehicleNumber:
          vehicleController.text,
      services: services,
      subtotal: subtotal,
      gstAmount: gstAmount,
      grandTotal: grandTotal,
      isGstApplied: gstEnabled,
      createdAt:
          widget.invoice.createdAt,
    );

    await ref
        .read(invoiceProvider.notifier)
        .updateInvoice(
          updatedInvoice,
        );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Invoice',
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          TextField(
            controller:
                customerNameController,
            decoration:
                const InputDecoration(
              labelText:
                  'Customer Name',
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller:
                phoneController,
            decoration:
                const InputDecoration(
              labelText:
                  'Phone Number',
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller:
                vehicleController,
            decoration:
                const InputDecoration(
              labelText:
                  'Vehicle Number',
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: addService,
            child: const Text(
              'Add Service',
            ),
          ),

          const SizedBox(height: 12),

          ...List.generate(
            serviceControllers.length,
            (index) =>
                ServiceItemTile(
              serviceController:
                  serviceControllers[
                      index],
              amountController:
                  amountControllers[
                      index],
              onDelete: () =>
                  removeService(
                    index,
                  ),
              onAmountChanged: () {
                setState(() {});
              },
            ),
          ),

          SwitchListTile(
            value: gstEnabled,
            title: const Text(
              'Apply GST',
            ),
            onChanged: (value) {
              setState(() {
                gstEnabled = value;
              });
            },
          ),

          const SizedBox(height: 20),

          Text(
            'Grand Total: ₹${grandTotal.toStringAsFixed(2)}',
            style:
                const TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed:
                  updateInvoice,
              child: const Text(
                'UPDATE INVOICE',
              ),
            ),
          ),
        ],
      ),
    );
  }
}