import 'dart:io';

import 'package:launchpad_binder/entity/entity.dart';
import 'package:launchpad_binder/service/keyboard_service/keyboard_service_linux.dart';
import 'package:launchpad_binder/service/keyboard_service/keyboard_service_windows.dart';

abstract class KeyboardService {
  Future<void> press(KeyCode key);
  Future<void> release(KeyCode key);
  Future<void> tap(KeyCode key);
  Future<void> sendCombination(List<KeyCode> keys);

  factory KeyboardService() {
    if (Platform.isLinux) return LinuxKeyboardService();
    if (Platform.isWindows) return WindowsKeyboardService();
    throw UnsupportedError('Platform not supported');
  }
}
