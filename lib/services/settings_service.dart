import 'package:hive/hive.dart';

import '../core/constants/hive_boxes.dart';
import '../models/garage_settings_model.dart';

class SettingsService {
  static Box get _settingsBox =>
      Hive.box(HiveBoxes.settingsBox);

  static Future<void> saveSettings(
    GarageSettingsModel settings,
  ) async {
    await _settingsBox.put(
      'garage_settings',
      settings.toMap(),
    );
  }

  static GarageSettingsModel getSettings() {
    final data =
        _settingsBox.get('garage_settings');

    if (data == null) {
      return GarageSettingsModel.empty();
    }

    return GarageSettingsModel.fromMap(
      Map<dynamic, dynamic>.from(data),
    );
  }
}