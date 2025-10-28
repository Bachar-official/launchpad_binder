import 'package:launchpad_binder/entity/interface/launchpad_color.dart';

enum Mk2Palette implements LaunchpadColor {
  off((dark: 0, middle: 0, light: 0)),
  white((dark: 1, middle: 2, light: 3)),
  red((dark: 7, middle: 6, light: 5)),
  orange((dark: 11, middle: 10, light: 9)),
  yellow((dark: 15, middle: 14, light: 13)),
  greenWarm((dark: 19, middle: 18, light: 17)),
  green((dark: 23, middle: 22, light: 21)),
  aqua((dark: 27, middle: 26, light: 25)),
  cyan((dark: 31, middle: 30, light: 29)),
  sky((dark: 35, middle: 34, light: 33)),
  blue((dark: 39, middle: 38, light: 37)),
  indigo((dark: 43, middle: 42, light: 41)),
  purple((dark: 47, middle: 46, light: 45)),
  violet((dark: 51, middle: 50, light: 49)),
  magenta((dark: 55, middle: 54, light: 53)),
  fuchsia((dark: 59, middle: 58, light: 57)),
  amber((dark: 63, middle: 62, light: 61));

  @override final Color3D value;
  
  const Mk2Palette(this.value);  
}