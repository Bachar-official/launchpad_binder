import 'dart:io';

import 'package:launchpad_binder/entity/entity.dart';
import 'package:launchpad_binder/service/service.dart';

class WindowsKeyboardService implements KeyboardService {
  const WindowsKeyboardService();

  String _keyName(KeyCode key) {
    switch (key) {
      case KeyCode.enter:
        return 'ENTER';
      case KeyCode.space:
        return 'SPACE';
      case KeyCode.ctrlLeft:
      case KeyCode.ctrlRight:
        return 'CONTROL';
      case KeyCode.altLeft:
      case KeyCode.altRight:
        return 'MENU';
      case KeyCode.shiftLeft:
      case KeyCode.shiftRight:
        return 'SHIFT';
      default:
        return key.name.toUpperCase();
    }
  }

  Future<void> _sendKeys(String keys) async {
    await Process.run(
      'powershell',
      ['-Command', 'Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait("$keys")'],
    );
  }

  @override
  Future<void> press(KeyCode key) => _sendKeys('{${_keyName(key)}}');

  @override
  Future<void> release(KeyCode key) async {}

  @override
  Future<void> tap(KeyCode key) => _sendKeys('{${_keyName(key)}}');

  @override
  Future<void> sendCombination(List<KeyCode> keys) async {
    final combo = keys.map((k) => '^%${_keyName(k)}').join('');
    await _sendKeys(combo);
  }
}
