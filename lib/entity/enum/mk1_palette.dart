import 'package:launchpad_binder/entity/interface/launchpad_color.dart';

enum Mk1Palette implements LaunchpadColor {
  off((dark: 0, middle: 0, light: 0)),

  red((dark: 1, middle: 2, light: 3)),

  green((dark: 28, middle: 32, light: 48)),

  orange((dark: 17, middle: 18, light: 19)),

  yellow((dark: 46, middle: 35, light: 51));

  @override final Color3D value;
  
  const Mk1Palette(this.value);  
}