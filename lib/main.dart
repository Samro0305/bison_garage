import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'database/hive_database.dart';
import 'screens/splash/splash_screen.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveDatabase.initialize();

  runApp(
    const ProviderScope(
      child: BisonGarageApp(),
    ),
  );
}

class BisonGarageApp extends ConsumerWidget {
  const BisonGarageApp({super.key});

@override
Widget build(
  BuildContext context,
  WidgetRef ref,
) {
  final isDark =
    ref.watch(darkModeProvider);

return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'BISON GARAGE',

  theme: ThemeData.light(),

  darkTheme: AppTheme.darkTheme,

  themeMode:
      isDark
          ? ThemeMode.dark
          : ThemeMode.light,

  home: const SplashScreen(),
);
  }
}