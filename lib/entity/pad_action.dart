import 'dart:io';

import 'package:launchpad_binder/entity/entity.dart';
import 'package:launchpad_binder/service/service.dart';

const _type = 'type';
const _programType = 'program';
const _keyboardType = 'keyboard';
const _command = 'command';
const _keys = 'keys';

abstract class PadAction {
  const PadAction();

  Future<void> execute();

  factory PadAction.fromMap(Map<String, dynamic> map, {KeyboardService? keyService}) {
    if (map[_type] == _keyboardType && keyService != null) {
      return KeyboardPadAction.fromMap(map, keyService: keyService);
    } else if (map[_type] == _programType) {
      return ProgramPadAction.fromMap(map);
    }
    throw Exception('No KeyboardService provided!');
  }
}

class ProgramPadAction extends PadAction {
  final String command;
  const ProgramPadAction({required this.command});

  @override
  Future<void> execute() async {
    final fullCommand = command.split(' ');
    await Process.run(fullCommand.first, [...fullCommand.sublist(1)]);
  }

  Map<String, dynamic> toMap() => {_type: _programType, _command: command};

  factory ProgramPadAction.fromMap(Map<String, dynamic> map) =>
      ProgramPadAction(command: map[_command]);
}

class KeyboardPadAction extends PadAction {
  final List<KeyCode> keys;
  final KeyboardService keyService;
  const KeyboardPadAction({required this.keyService, required this.keys});

  @override
  Future<void> execute() async {
    keyService.sendCombination(keys);
  }

  Map<String, dynamic> toMap() => {
    _type: _keyboardType,
    _keys: keys.map((el) => el.name).toList(),
  };

  factory KeyboardPadAction.fromMap(
    Map<String, dynamic> map, {
    required KeyboardService keyService,
  }) => KeyboardPadAction(
    keyService: keyService,
    keys: (map[_keys] as List<dynamic>)
        .map((el) => KeyCode.fromString(el))
        .toList(),
  );
}
