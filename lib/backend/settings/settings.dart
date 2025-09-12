import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:aandm/models/settings/settings.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Settings {
  late SettingsModel _settings;

  Future<SettingsModel> loadSettings() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/settings.json');

    if (await file.exists()) {
      // Load the existing settings
      final jsonString = await file.readAsString();
      final existingHash = md5.convert(utf8.encode(jsonString)).toString();

      // Load the settings from assets
      final assetJsonString =
          await rootBundle.loadString('assets/settings.json');
      final assetHash = md5.convert(utf8.encode(assetJsonString)).toString();

      // Compare hashes
      if (assetHash != existingHash) {
        // Overwrite with the new version from assets
        await file.writeAsString(assetJsonString);
        _settings = SettingsModel.fromJson(
          json.decode(assetJsonString) as Map<String, dynamic>,
        );
      } else {
        // Load the existing settings
        _settings = SettingsModel.fromJson(
          json.decode(jsonString) as Map<String, dynamic>,
        );
      }
    } else {
      // If the file doesn't exist, copy it from assets
      final jsonString = await rootBundle.loadString('assets/settings.json');
      await file.writeAsString(jsonString);
      _settings = SettingsModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    }
    return _settings;
  }

  SettingsModel get settings => _settings;
}
