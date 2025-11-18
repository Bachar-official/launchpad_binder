import 'package:launchpad_binder/entity/entity.dart';
import 'package:rtmidi_dart/rtmidi_dart.dart';

class WizardState {
  final int step;
  final Map<Pad, MidiPad> mapping;
  final Pad? currentMappingPad;
  final List<MidiDevice> devices;
  final String? deviceId;

  const WizardState({
    required this.step,
    required this.mapping,
    required this.currentMappingPad,
    required this.devices,
    required this.deviceId,
  });

  factory WizardState.initial() => WizardState(
    step: 0,
    mapping: {},
    currentMappingPad: null,
    devices: [],
    deviceId: null,
  );

  WizardState copyWith({
    int? step,
    Map<Pad, MidiPad>? profileMap,
    Pad? currentMappingPad,
    bool nullableMappingPad = false,
    List<MidiDevice>? devices,
    String? deviceId,
    bool nullableDeviceId = false,
  }) => WizardState(
    step: step ?? this.step,
    mapping: profileMap ?? mapping,
    currentMappingPad: nullableMappingPad
        ? null
        : currentMappingPad ?? this.currentMappingPad,
    devices: devices ?? this.devices,
    deviceId: nullableDeviceId ? null : deviceId ?? this.deviceId,
  );

  DeviceConfig toConfig() => DeviceConfig(
    deviceId: deviceId ?? '',
    mapping: mapping,
  );
}
