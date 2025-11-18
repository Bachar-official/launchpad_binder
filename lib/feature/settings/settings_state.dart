import 'package:launchpad_binder/entity/device_config.dart';
import 'package:rtmidi_dart/rtmidi_dart.dart';

class SettingsState {
  final bool isLoading;
  final DeviceConfig? config;
  final MidiDevice? connectedDevice;
  final int profile;

  SettingsState({required this.isLoading, required this.config, required this.connectedDevice, required this.profile});

  SettingsState.initial() : isLoading = false, config = null, connectedDevice = null, profile = 0;

  SettingsState copyWith({
    bool? isLoading,
    DeviceConfig? config,
    bool nullableConfig = false,
    MidiDevice? connectedDevice,
    bool nullableDevice = false,
    int? profile,
  }) => SettingsState(
    isLoading: isLoading ?? this.isLoading,
    config: nullableConfig ? null : config ?? this.config,
    connectedDevice: nullableDevice ? null : connectedDevice ?? this.connectedDevice,
    profile: profile ?? this.profile,
  );
}
