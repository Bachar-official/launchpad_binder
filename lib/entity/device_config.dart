import 'package:launchpad_binder/entity/enum/pad.dart';

class DeviceConfig {
  final String deviceId;
  final Map<Pad, int> mapping;

  const DeviceConfig({
    required this.deviceId,
    required this.mapping,
  });

  factory DeviceConfig.fromMap(Map<String, dynamic> map) {
    final Map<Pad, int> mapping = (map['mapping'] as Map<String, dynamic>).map((k, v) => MapEntry(Pad.fromString(k), v as int));
    
    return DeviceConfig( 
    deviceId: map['deviceId'],
    mapping: mapping,
  );
  }

  Map<String, dynamic> toMap() => {
    'deviceId': deviceId,
    'mapping': mapping.map((k, v) => MapEntry(k.toString(), v)),
  };
}
