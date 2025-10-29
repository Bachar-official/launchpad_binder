import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/entity/enum/palette.dart';
import 'package:launchpad_binder/entity/enum/pad.dart';

class WizardState {
  final int step;
  final Palette? palette;
  final Map<Pad, int> profileMap;
  final Pad? currentMappingPad;
  final List<MidiDevice> devices;

  const WizardState({
    required this.step,
    required this.palette,
    required this.profileMap,
    required this.currentMappingPad,
    required this.devices,
  });

  factory WizardState.initial() => WizardState(
        step: 0,
        palette: null,
        profileMap: {},
        currentMappingPad: null,
        devices: [],
      );

  WizardState copyWith({
    int? step,
    Palette? palette,
    Map<Pad, int>? profileMap,
    Pad? currentMappingPad,
    bool nullableMappingPad = false,
    List<MidiDevice>? devices,
  }) => WizardState(
        step: step ?? this.step,
        palette: palette ?? this.palette,
        profileMap: profileMap ?? this.profileMap,
        currentMappingPad: nullableMappingPad ? null : currentMappingPad ?? this.currentMappingPad,
        devices: devices ?? this.devices,
      );
}