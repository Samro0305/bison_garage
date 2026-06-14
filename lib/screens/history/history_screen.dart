import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'invoice_details_screen.dart';

import '../../models/invoice_model.dart';
import '../../widgets/invoice_tile.dart';
import '../../providers/firestore_invoice_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _filter = 'ALL';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(firestoreInvoiceProvider);

    return invoicesAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text(error.toString()),
        ),
      ),
      data: (invoices) {
        final List<InvoiceModel> filteredInvoices =
            invoices.where((invoice) {
          final query = _searchQuery.trim().toLowerCase();

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
                  invoice.createdAt.year == now.year &&
                  invoice.createdAt.month == now.month &&
                  invoice.createdAt.day == now.day;
              break;

            case 'MONTH':
              matchesFilter =
                  invoice.createdAt.year == now.year &&
                  invoice.createdAt.month == now.month;
              break;

            case 'YEAR':
              matchesFilter =
                  invoice.createdAt.year == now.year;
              break;

            default:
              matchesFilter = true;
          }

          return matchesSearch && matchesFilter;
        }).toList();

        filteredInvoices.sort(
          (a, b) => b.invoiceNumber.compareTo(a.invoiceNumber),
        );

        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText:
                            'Search Customer / Vehicle / Invoice',
                        prefixIcon: const Icon(
                          Icons.search,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                ),
                                onPressed: () {
                                  _searchController.clear();

                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border:
                            const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterButton('ALL'),
                          _buildFilterButton('TODAY'),
                          _buildFilterButton('MONTH'),
                          _buildFilterButton('YEAR'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: filteredInvoices.isEmpty
                    ? const Center(
                        child: Text(
                          'No Invoices Found',
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        itemCount:
                            filteredInvoices.length,
                        itemBuilder:
                            (context, index) {
                          final invoice =
                              filteredInvoices[index];

                          return InvoiceTile(
                            invoice: invoice,
                            index: index,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      InvoiceDetailsScreen(
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

  Widget _buildFilterButton(String value) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
      ),
      child: ChoiceChip(
        label: Text(value),
        selected: _filter == value,
        onSelected: (_) {
          setState(() {
            _filter = value;
          });
        },
      ),
    );
  }
}