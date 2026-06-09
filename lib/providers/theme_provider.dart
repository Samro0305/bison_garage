import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/theme_service.dart';

final darkModeProvider =
    StateProvider<bool>(
  (ref) => ThemeService.getThemeMode(),
);