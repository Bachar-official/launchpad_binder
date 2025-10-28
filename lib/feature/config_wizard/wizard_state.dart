import 'package:launchpad_binder/entity/enum/palette.dart';
import 'package:launchpad_binder/entity/enum/profile_pad.dart';

class WizardState {
  final int step;
  final Palette? palette;
  final Map<ProfilePad, int> profileMap;
  final ProfilePad? currentMappingPad;

  const WizardState({
    required this.step,
    required this.palette,
    required this.profileMap,
    this.currentMappingPad,
  });

  factory WizardState.initial() => WizardState(
        step: 0,
        palette: null,
        profileMap: {},
        currentMappingPad: null,
      );

  WizardState copyWith({
    int? step,
    Palette? palette,
    Map<ProfilePad, int>? profileMap,
    ProfilePad? currentMappingPad,
    bool nullableMappingPad = false,
  }) => WizardState(
        step: step ?? this.step,
        palette: palette ?? this.palette,
        profileMap: profileMap ?? this.profileMap,
        currentMappingPad: nullableMappingPad ? null : currentMappingPad ?? this.currentMappingPad,
      );
}