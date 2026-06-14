import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/user_role.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/theme_service.dart';
import '../history/staff_history_screen.dart';
import '../billing/billing_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../history/history_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends ConsumerState<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(authProvider);

    final bool isOwner =
        role == UserRole.owner;

    final List<Widget> pages = isOwner
        ? const [
            DashboardScreen(),
            BillingScreen(),
            HistoryScreen(),
            ReportsScreen(),
            SettingsScreen(),
          ]
        : const [
    BillingScreen(),
    StaffHistoryScreen(),
  ];

    final List<BottomNavigationBarItem> items =
        isOwner
            ? const [
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
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: 'Billing',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'History',
                ),
              ];

    if (currentIndex >= pages.length) {
      currentIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onDoubleTap: () async {
            final newValue =
                !ref.read(darkModeProvider);

            ref
                .read(
                  darkModeProvider.notifier,
                )
                .state = newValue;

            await ThemeService.saveThemeMode(
              newValue,
            );
          },
          child: Text(
            isOwner
                ? 'BISON GARAGE'
                : 'BISON GARAGE - STAFF',
          ),
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,
        type:
            BottomNavigationBarType.fixed,
        items: items,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}