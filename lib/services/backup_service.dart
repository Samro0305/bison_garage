import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/constants/hive_boxes.dart';
import '../models/invoice_model.dart';
import '../models/garage_settings_model.dart';
import 'firestore_invoice_service.dart';
import 'settings_service.dart';

class BackupService {
  static Future<void> exportBackup() async {
    final invoices =
    await FirestoreInvoiceService
        .getAllInvoices();

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

    final timestamp =
    DateFormat(
      'yyyy_MM_dd_HH_mm',
    ).format(
      DateTime.now(),
    );

final file = File(
  '${directory.path}/backup_$timestamp.json',
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


await SettingsService.saveSettings(
  settings.copyWith(
    lastBackupDate:
        DateTime.now().toIso8601String(),
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

  final settingsBox =
      Hive.box(HiveBoxes.settingsBox);

  await settingsBox.clear();

  await FirestoreInvoiceService
      .clearAllInvoices();

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

    await FirestoreInvoiceService
        .saveInvoice(invoice);
  }

  return true;
}

}