import 'package:launchpad_binder/entity/entity.dart';

const _mapping = 'mapping';
const _deviceId = 'deviceId';

class DeviceConfig {
  final String deviceId;
  final Map<Pad, MidiPad> mapping;

  const DeviceConfig({required this.deviceId, required this.mapping});

  factory DeviceConfig.fromMap(Map<String, dynamic> map) {
    final Map<Pad, MidiPad> mapping = (map[_mapping] as Map<String, dynamic>)
        .map(
          (k, v) => MapEntry(
            Pad.fromString(k),
            MidiPad.fromMap(v as Map<String, dynamic>),
          ),
        );

    return DeviceConfig(deviceId: map[_deviceId], mapping: mapping);
  }

  Map<String, dynamic> toMap() => {
    _deviceId: deviceId,
    _mapping: mapping.map((k, v) => MapEntry(k.toString(), v.toMap())),
  };
}
