import 'package:hive/hive.dart';

class ThemeService {
  static const String boxName = 'themeBox';
  static const String key = 'isDark';

  static bool getThemeMode() {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: false);
  }

  static Future<void> saveThemeMode(
    bool isDark,
  ) async {
    final box = Hive.box(boxName);
    await box.put(key, isDark);
  }
}