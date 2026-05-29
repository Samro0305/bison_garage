import 'package:flutter/material.dart';

import '../billing/billing_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../history/history_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    DashboardScreen(),
    BillingScreen(),
    HistoryScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BISON GARAGE'),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Billing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}