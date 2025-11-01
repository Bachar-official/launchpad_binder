import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:launchpad_binder/entity/device_config.dart';
const _fileName = 'deviceConfig.conf';

class ConfigService {
  final configNotifier = ValueNotifier<DeviceConfig?>(null);

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
    final config = DeviceConfig.fromMap(map);
    configNotifier.value = config;
    return DeviceConfig.fromMap(map);
  }

  Future<void> saveConfig(DeviceConfig config) async {
    configNotifier.value = config;
    final file = File(_fileName);
    final content = config.toMap();
    await file.writeAsString(jsonEncode(content));
  }
}
