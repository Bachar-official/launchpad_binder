import 'package:launchpad_binder/entity/enum/palette.dart';
import 'package:launchpad_binder/entity/enum/profile_pad.dart';

class WizardState {
  final int step;
  final Map<ProfilePad, int> profileMap;
  final Palette palette;

  const WizardState({required this.palette, required this.profileMap, required this.step});

  WizardState.initial(): palette = Palette.mk1, profileMap = {}, step = 0;

  WizardState copyWith({
    int? step,
    Map<ProfilePad, int>? profileMap,
    Palette? palette,
  }) => WizardState(palette: palette ?? this.palette, profileMap: profileMap ?? this.profileMap, step: step ?? this.step);
}