import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../providers/invoice_provider.dart';
import '../../models/garage_settings_model.dart';
import '../../services/settings_service.dart';
import '../../services/backup_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends ConsumerState<SettingsScreen> {

  final garageNameController =
      TextEditingController();

  final ownerNameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final gstController =
      TextEditingController();

  final currentPasswordController =
    TextEditingController();

final newPasswordController =
    TextEditingController();

final confirmPasswordController =
    TextEditingController();

  String logoPath = '';
  String signaturePath = '';

  @override
void initState() {
  super.initState();

  final settings =
      SettingsService.getSettings();

  garageNameController.text =
      settings.garageName;

  ownerNameController.text =
      settings.ownerName;

  phoneController.text =
      settings.phoneNumber;

  addressController.text =
      settings.address;

  gstController.text =
      settings.gstNumber;

  logoPath =
      settings.logoPath;

  signaturePath =
      settings.signaturePath;

  if (settings.lastBackupDate.isNotEmpty) {
    final lastBackup =
        DateTime.parse(
      settings.lastBackupDate,
    );

    final daysSinceBackup =
        DateTime.now()
            .difference(lastBackup)
            .inDays;

    if (daysSinceBackup >= 7) {
      WidgetsBinding.instance
          .addPostFrameCallback(
        (_) {
          if (!mounted) return;

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text(
                'Backup Reminder',
              ),
              content: const Text(
                'It has been more than 7 days since your last backup.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    'Later',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(
                      context,
                    );

                    await BackupService
                        .exportBackup();

                    if (!mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Backup Exported',
                        ),
                      ),
                    );

                    setState(() {});
                  },
                  child: const Text(
                    'Backup Now',
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}

  Future<void> saveSettings() async {
  final settings = GarageSettingsModel(
  garageName: garageNameController.text.trim(),
  ownerName: ownerNameController.text.trim(),
  phoneNumber: phoneController.text.trim(),
  address: addressController.text.trim(),
  gstNumber: gstController.text.trim(),
  logoPath: logoPath,
  signaturePath: signaturePath,
  password: SettingsService.getSettings().password,
  lastBackupDate:
      SettingsService
          .getSettings()
          .lastBackupDate,
);

  await SettingsService.saveSettings(
    settings,
  );


    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Settings Saved',
        ),
      ),
    );
  }

  Future<void> changePassword() async {
  final settings =
      SettingsService.getSettings();

  if (currentPasswordController.text.trim() !=
      settings.password) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Current password is incorrect',
        ),
      ),
    );
    return;
  }

  if (newPasswordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Enter a new password',
        ),
      ),
    );
    return;
  }

  if (newPasswordController.text.trim() !=
      confirmPasswordController.text.trim()) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Passwords do not match',
        ),
      ),
    );
    return;
  }

  final updatedSettings =
      settings.copyWith(
    password:
        newPasswordController.text.trim(),
  );

  await SettingsService.saveSettings(
    updatedSettings,
  );

  currentPasswordController.clear();
  newPasswordController.clear();
  confirmPasswordController.clear();

  if (!mounted) return;

  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content: Text(
        'Password Changed Successfully',
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: garageNameController,
            decoration:
                const InputDecoration(
              labelText: 'Garage Name',
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: ownerNameController,
            decoration:
                const InputDecoration(
              labelText: 'Owner Name',
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: phoneController,
            decoration:
                const InputDecoration(
              labelText: 'Phone Number',
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: addressController,
            maxLines: 3,
            decoration:
                const InputDecoration(
              labelText: 'Address',
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

         TextField(
  controller: gstController,
  decoration: const InputDecoration(
    labelText: 'GST Number',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 12),

SizedBox(
  height: 55,
  child: ElevatedButton(
    onPressed: () async {
      final picker =
          ImagePicker();

      final image =
          await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      setState(() {
        logoPath = image.path;
      });
    },
    child: const Text(
      'SELECT LOGO',
    ),
  ),
),

const SizedBox(height: 12),

if (logoPath.isNotEmpty)
  Container(
    height: 120,
    padding: const EdgeInsets.all(8),
    child: Image.file(
      File(logoPath),
    ),
  ),

const SizedBox(height: 12),

SizedBox(
  height: 55,
  child: ElevatedButton(
    onPressed: () async {
      final picker = ImagePicker();

      final image =
          await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      setState(() {
        signaturePath = image.path;
      });
    },
    child: const Text(
      'SELECT SIGNATURE',
    ),
  ),
),

const SizedBox(height: 12),

if (signaturePath.isNotEmpty)
  Container(
    height: 100,
    padding: const EdgeInsets.all(8),
    child: Image.file(
      File(signaturePath),
    ),
  ),

  const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton(
    onPressed: saveSettings,
    child: const Text(
      'SAVE SETTINGS',
    ),
  ),
),

const SizedBox(height: 24),

const Text(
  'Security',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 12),

TextField(
  controller:
      currentPasswordController,
  obscureText: true,
  decoration: const InputDecoration(
    labelText: 'Current Password',
  ),
),

const SizedBox(height: 12),

TextField(
  controller: newPasswordController,
  obscureText: true,
  decoration: const InputDecoration(
    labelText: 'New Password',
  ),
),

const SizedBox(height: 12),

TextField(
  controller:
      confirmPasswordController,
  obscureText: true,
  decoration: const InputDecoration(
    labelText: 'Confirm Password',
  ),
),

const SizedBox(height: 12),

const SizedBox(height: 20),

Center(
  child: SizedBox(
    width: 220,
    height: 50,
    child: ElevatedButton(
      onPressed: changePassword,
      child: const Text(
        'CHANGE PASSWORD',
      ),
    ),
  ),
),

const SizedBox(height: 12),

Builder(
  builder: (context) {
    final lastBackupDate =
        SettingsService
            .getSettings()
            .lastBackupDate;

    if (lastBackupDate.isEmpty) {
      return const SizedBox();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.backup,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                'Last Backup:\n${DateFormat(
  'dd MMM yyyy, hh:mm a',
).format(
  DateTime.parse(lastBackupDate),
)}'
              ),
            ),
          ],
        ),
      ),
    );
  },
),

const SizedBox(height: 12),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          await BackupService.exportBackup();

          if (!mounted) return;

          ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(
              content: Text('Backup Exported'),
            ),
          );
        },
        child: const Text(
          'EXPORT BACKUP',
          textAlign: TextAlign.center,
        ),
      ),
    ),

    const SizedBox(width: 12),

    SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          final restored =
              await BackupService.restoreBackup();

          if (!mounted) return;

          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Text(
                restored
                    ? 'Backup Restored'
                    : 'Restore Cancelled',
              ),
            ),
          );

          if (restored) {
           

            setState(() {
              final settings =
                  SettingsService.getSettings();

              garageNameController.text =
                  settings.garageName;

              ownerNameController.text =
                  settings.ownerName;

              phoneController.text =
                  settings.phoneNumber;

              addressController.text =
                  settings.address;

              gstController.text =
                  settings.gstNumber;
            });
          }
        },
        child: const Text(
          'RESTORE BACKUP',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ],
),

const SizedBox(height: 20),



      ],
    ),
  );
}

}


