import 'package:flutter/material.dart';

import '../../services/analytics_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildCard(
            'Total Revenue',
            '₹${AnalyticsService.totalRevenue.toStringAsFixed(2)}',
          ),

          buildCard(
            'Monthly Revenue',
            '₹${AnalyticsService.monthlyRevenue.toStringAsFixed(2)}',
          ),

          buildCard(
            'Today Revenue',
            '₹${AnalyticsService.todayRevenue.toStringAsFixed(2)}',
          ),

          buildCard(
            'GST Collected',
            '₹${AnalyticsService.totalGstCollected.toStringAsFixed(2)}',
          ),

          buildCard(
            'Total Invoices',
            AnalyticsService.totalInvoices.toString(),
          ),
        ],
      ),
    );
  }

  Widget buildCard(
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}