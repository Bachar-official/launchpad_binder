import 'package:launchpad_binder/entity/entity.dart';

class DeviceConfig {
  final String deviceId;
  final Map<Pad, MidiPad> mapping;

  const DeviceConfig({required this.deviceId, required this.mapping});

  factory DeviceConfig.fromMap(Map<String, dynamic> map) {
    final Map<Pad, MidiPad> mapping = (map['mapping'] as Map<String, dynamic>)
        .map(
          (k, v) => MapEntry(
            Pad.fromString(k),
            MidiPad.fromMap(v as Map<String, dynamic>),
          ),
        );

    return DeviceConfig(deviceId: map['deviceId'], mapping: mapping);
  }

  Map<String, dynamic> toMap() => {
    'deviceId': deviceId,
    'mapping': mapping.map((k, v) => MapEntry(k.toString(), v.toMap())),
  };
}
