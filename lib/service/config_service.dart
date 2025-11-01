import 'dart:convert';
import 'dart:io';

import 'package:launchpad_binder/entity/device_config.dart';
const _fileName = 'deviceConfig.conf';

class ConfigService {

  Future<DeviceConfig?> getConfig() async {
    final file = File(_fileName);
    if (!file.existsSync()) {
      return null;
    }
    final content = await file.readAsString();
    if (content.isEmpty) {
      return null;
    }
    final map = jsonDecode(content);
    return DeviceConfig.fromMap(map);
  }

  Future<void> saveConfig(DeviceConfig config) async {
    final file = File(_fileName);
    final content = config.toMap();
    await file.writeAsString(jsonEncode(content));
  }
}
