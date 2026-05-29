import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/hive_database.dart';
import 'screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveDatabase.initialize();

  runApp(
    const ProviderScope(
      child: BisonGarageApp(),
    ),
  );
}

class BisonGarageApp extends StatelessWidget {
  const BisonGarageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BISON GARAGE',
      home: const SplashScreen(),
    );
  }
}