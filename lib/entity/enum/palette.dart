import 'package:launchpad_binder/entity/enum/mk1_palette.dart';
import 'package:launchpad_binder/entity/enum/mk2_palette.dart';
import 'package:launchpad_binder/entity/interface/launchpad_color.dart';

enum Palette {
  mk1('Mk1 (with only red, yellow and green)'),
  mk2('Mk2 (full RGB color)');

  final String value;

  const Palette(this.value);

  List<LaunchpadColor> get colors {
    switch (this) {
      case mk1: return Mk1Palette.values.cast<LaunchpadColor>();
      case mk2: return Mk2Palette.values.cast<LaunchpadColor>();
    }
  }
}