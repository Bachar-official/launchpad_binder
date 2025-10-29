import 'dart:convert';
import 'dart:io';

import 'package:launchpad_binder/entity/device_config.dart';
import 'package:logger/logger.dart';

const _fileName = 'deviceConfig.conf';

class ConfigService {
  final Logger logger;

  const ConfigService({required this.logger});

  Future<DeviceConfig?> getConfig() async {
    logger.d('Trying go read config');

    final file = File(_fileName);
    if (!file.existsSync()) {
      return null;
    }
    final content = await file.readAsString();
    if (content.isEmpty) {
      return null;
    }
    final map = jsonDecode(content);
    logger.i('Config got successfully');
    return DeviceConfig.fromMap(map);
  }

  Future<void> saveConfig(DeviceConfig config) async {
    logger.d('Try to save config');
    final file = File(_fileName);
    final content = config.toMap();
    await file.writeAsString(jsonEncode(content));
    logger.i('Config saved!');
  }
}
