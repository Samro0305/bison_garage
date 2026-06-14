import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'invoice_details_screen.dart';
import 'staff_invoice_details_screen.dart';

import '../../models/invoice_model.dart';
import '../../providers/firestore_invoice_provider.dart';
import '../../widgets/invoice_tile.dart';

class StaffHistoryScreen extends ConsumerStatefulWidget {
  const StaffHistoryScreen({super.key});

  @override
  ConsumerState<StaffHistoryScreen> createState() =>
      _StaffHistoryScreenState();
}

class _StaffHistoryScreenState
    extends ConsumerState<StaffHistoryScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';
  String _filter = 'ALL';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync =
        ref.watch(firestoreInvoiceProvider);

    return invoicesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(error.toString()),
      ),
      data: (invoices) {
        final List<InvoiceModel>
            filteredInvoices =
            invoices.where((invoice) {
          final query =
              _searchQuery.trim().toLowerCase();

          bool matchesSearch =
              query.isEmpty ||
                  invoice.customerName
                      .toLowerCase()
                      .contains(query) ||
                  invoice.vehicleNumber
                      .toLowerCase()
                      .contains(query) ||
                  invoice.invoiceNumber
                      .toLowerCase()
                      .contains(query);

          final now = DateTime.now();

          bool matchesFilter = true;

          switch (_filter) {
            case 'TODAY':
              matchesFilter =
                  invoice.createdAt.year ==
                          now.year &&
                      invoice.createdAt.month ==
                          now.month &&
                      invoice.createdAt.day ==
                          now.day;
              break;

            case 'MONTH':
              matchesFilter =
                  invoice.createdAt.year ==
                          now.year &&
                      invoice.createdAt.month ==
                          now.month;
              break;

            case 'YEAR':
              matchesFilter =
                  invoice.createdAt.year ==
                      now.year;
              break;

            default:
              matchesFilter = true;
          }

          return matchesSearch &&
              matchesFilter;
        }).toList()
          ..sort(
            (a, b) => b.createdAt.compareTo(
              a.createdAt,
            ),
          );

        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(16),
                child: TextField(
                  controller:
                      _searchController,
                  decoration:
                      const InputDecoration(
                    hintText:
                        'Search Customer / Vehicle / Invoice',
                    prefixIcon:
                        Icon(Icons.search),
                    border:
                        OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery =
                          value;
                    });
                  },
                ),
              ),
              Expanded(
                child:
                    filteredInvoices.isEmpty
                        ? const Center(
                            child: Text(
                              'No Invoices Found',
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                filteredInvoices
                                    .length,
                            itemBuilder:
                                (
                                  context,
                                  index,
                                ) {
                              final invoice =
                                  filteredInvoices[
                                      index];

                              return InvoiceTile(
  invoice: invoice,
  index: index,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoiceDetailsScreen(
          invoice: invoice,
          index: index,
        ),
      ),
    );
  },
  onDelete: null,
);
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}