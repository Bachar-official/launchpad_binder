import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:launchpad_binder/entity/device_config.dart';

const _configFileName = 'deviceConfig.conf';
const _dictionaryFileName = 'dictionary.conf';

class ConfigService {
  final _configNotifier = ValueNotifier<DeviceConfig?>(null);
  final _dictNotifier = ValueNotifier<Map<int, int>?>(null);

  DeviceConfig? get config => _configNotifier.value;
  Map<int, int>? get mapping => _dictNotifier.value;

  Future<DeviceConfig?> getConfig() async {
    final file = File(_configFileName);
    if (!file.existsSync()) {
      return null;
    }
    final content = await file.readAsString();
    if (content.isEmpty) {
      return null;
    }
    final map = jsonDecode(content);
    final config = DeviceConfig.fromMap(map);
    _configNotifier.value = config;
    return DeviceConfig.fromMap(map);
  }

  Future<void> saveConfig(DeviceConfig config) async {
    final file = File(_configFileName);
    final content = config.toMap();
    await file.writeAsString(jsonEncode(content));
    _configNotifier.value = config;
  }

  Future<Map<int, int>?> getDictionary() async {
    final file = File(_dictionaryFileName);
    if (!file.existsSync()) {
      return null;
    }
    final content = await file.readAsString();
    if (content.isEmpty) {
      return null;
    }
    final map = jsonDecode(content) as Map<String, dynamic>;
    final dict = Map<int, int>.from(map.map((k, v) => MapEntry(int.parse(k), v)));
    _dictNotifier.value = dict;
    return dict;
  }

  Future<void> saveDictionary(Map<int, int> dictionary) async {
    final file = File(_dictionaryFileName);
    Map<String, dynamic> map = Map<String, dynamic>.from(dictionary.map((k, v) => MapEntry(k.toString(), v)));
    final content = jsonEncode(map);
    await file.writeAsString(content);
    _dictNotifier.value = dictionary;
  }
}
