import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/hive_boxes.dart';

class HiveDatabase {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    await Hive.openBox(
      HiveBoxes.settingsBox,
    );

    await Hive.openBox('themeBox');
  }
}

