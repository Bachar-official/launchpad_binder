import 'dart:io';
import 'package:launchpad_binder/entity/entity.dart';
import 'package:launchpad_binder/service/keyboard_service/keyboard_service.dart';

class LinuxKeyboardService implements KeyboardService {
  const LinuxKeyboardService();

  Future<void> _run(List<String> args) async {
    final tools = ['ydotool', 'xdotool', 'wtype'];
    for (final tool in tools) {
      final result = await Process.run('which', [tool]);
      if (result.exitCode == 0) {
        await Process.run(tool, args);
        return;
      }
    }
    throw Exception('No keyboard emulation tool found (ydotool, xdotool, or wtype)');
  }

  Future<String?> _detectTool() async {
    for (final tool in ['ydotool', 'xdotool', 'wtype']) {
      final result = await Process.run('which', [tool]);
      if (result.exitCode == 0) return tool;
    }
    return null;
  }

  String _keyName(KeyCode key) {
    if (KeyCode.funcKeys.contains(key)) {
      return key.name.toUpperCase();
    }
    switch (key) {
      case KeyCode.enter:
        return 'Return';
      case KeyCode.space:
        return 'space';
      case KeyCode.escape:
        return 'Escape';
      case KeyCode.tab:
        return 'Tab';
      case KeyCode.ctrlLeft:
        return 'ctrl';
      case KeyCode.altLeft:
        return 'alt';
      case KeyCode.shiftLeft:
        return 'shift';
      default:
        return key.name;
    }
  }

  @override
  Future<void> press(KeyCode key) async {
    final tool = await _detectTool();
    final name = _keyName(key);
    if (tool == 'xdotool') {
      await _run(['keydown', name]);
    } else {
      await _run(['key', 'down', name]);
    }
  }

  @override
  Future<void> release(KeyCode key) async {
    final tool = await _detectTool();
    final name = _keyName(key);
    if (tool == 'xdotool') {
      await _run(['keyup', name]);
    } else {
      await _run(['key', 'up', name]);
    }
  }

  @override
  Future<void> tap(KeyCode key) async {
    final tool = await _detectTool();
    final name = _keyName(key);
    if (tool == 'xdotool') {
      await _run(['key', name]);
    } else {
      await _run(['key', 'tap', name]);
    }
  }

  @override
  Future<void> sendCombination(List<KeyCode> keys) async {
    final tool = await _detectTool();
    final names = keys.map(_keyName).join('+');
    if (tool == 'xdotool') {
      await _run(['key', names]);
    } else {
      await _run(['key', 'tap', names]);
    }
  }
}
