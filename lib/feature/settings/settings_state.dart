import 'package:flutter_midi_command/flutter_midi_command.dart';

class SettingsState {
  final bool isLoading;
  final MidiDevice? activeDevice;
  final List<MidiDevice> devices;

  SettingsState({required this.activeDevice, required this.devices, required this.isLoading});

  SettingsState.initial() : activeDevice = null, devices = [], isLoading = false;

  SettingsState copyWith({
    List<MidiDevice>? devices,
    MidiDevice? activeDevice,
    bool nullableDevice = false,
    bool? isLoading,
  }) => SettingsState(
    activeDevice: nullableDevice ? null : activeDevice ?? this.activeDevice,
    devices: devices ?? this.devices,
    isLoading: isLoading ?? this.isLoading,
  );
}
