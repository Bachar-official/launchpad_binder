import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/entity/device_config.dart';

class SettingsState {
  final bool isLoading;
  final DeviceConfig? config;
  final MidiDevice? connectedDevice;

  SettingsState({required this.isLoading, required this.config, required this.connectedDevice});

  SettingsState.initial() : isLoading = false, config = null, connectedDevice = null;

  SettingsState copyWith({
    bool? isLoading,
    DeviceConfig? config,
    bool nullableConfig = false,
    MidiDevice? connectedDevice,
    bool nullableDevice = false,
  }) => SettingsState(
    isLoading: isLoading ?? this.isLoading,
    config: nullableConfig ? null : config ?? this.config,
    connectedDevice: nullableDevice ? null : connectedDevice ?? this.connectedDevice,
  );
}
