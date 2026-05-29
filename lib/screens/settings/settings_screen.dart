import 'package:flutter/material.dart';

import '../../models/garage_settings_model.dart';
import '../../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
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
  }

  Future<void> saveSettings() async {
    final settings =
        GarageSettingsModel(
      garageName:
          garageNameController.text.trim(),
      ownerName:
          ownerNameController.text.trim(),
      phoneNumber:
          phoneController.text.trim(),
      address:
          addressController.text.trim(),
      gstNumber:
          gstController.text.trim(),
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
            decoration:
                const InputDecoration(
              labelText: 'GST Number',
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: saveSettings,
              child: const Text(
                'SAVE SETTINGS',
              ),
            ),
          ),
        ],
      ),
    );
  }
}