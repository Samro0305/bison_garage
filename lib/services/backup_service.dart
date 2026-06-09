import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/constants/hive_boxes.dart';
import '../models/invoice_model.dart';
import '../models/garage_settings_model.dart';
import 'invoice_service.dart';
import 'settings_service.dart';

class BackupService {
  static Future<void> exportBackup() async {
    final invoices =
        InvoiceService.getAllInvoices();

    final settings =
        SettingsService.getSettings();

    final backupData = {
      'settings': settings.toMap(),
      'invoices': invoices
          .map((invoice) => invoice.toMap())
          .toList(),
    };

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/backup.json',
    );

    await file.writeAsString(
      jsonEncode(backupData),
    );

    await SharePlus.instance.share(
  ShareParams(
    files: [
      XFile(file.path),
    ],
    text: 'Bison Garage Backup',
  ),
);
  }

  static Future<bool> restoreBackup() async {
    final result =
        await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) {
      return false;
    }

    final path =
        result.files.single.path;

    if (path == null) {
      return false;
    }

    final file = File(path);

    final jsonData =
        jsonDecode(await file.readAsString());

    final invoicesBox =
        Hive.box(HiveBoxes.invoicesBox);

    final settingsBox =
        Hive.box(HiveBoxes.settingsBox);

    await invoicesBox.clear();
    await settingsBox.clear();

    final settings =
        GarageSettingsModel.fromMap(
      jsonData['settings'],
    );

    await settingsBox.put(
      'garage_settings',
      settings.toMap(),
    );

    final invoices =
        (jsonData['invoices'] as List)
            .cast<Map>();

    for (final item in invoices) {
      final invoice =
          InvoiceModel.fromMap(item);

      await invoicesBox.put(
        invoice.invoiceId,
        invoice.toMap(),
      );
    }

    return true;
  }
}