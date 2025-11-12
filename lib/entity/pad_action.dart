import 'dart:io';

import 'package:launchpad_binder/entity/entity.dart';
import 'package:launchpad_binder/service/service.dart';

abstract class PadAction {
  const PadAction();

  Future<void> execute();
}

class ProgramPadAction extends PadAction {
  final String command;
  const ProgramPadAction({required this.command});

  @override
  Future<void> execute() async {
    final fullCommand = command.split(' ');
    await Process.run(fullCommand.first, [...fullCommand.sublist(1)]);
  }
}

class KeyboardPadAction extends PadAction {
  final List<KeyCode> keys;
  final KeyboardService keyService;
  const KeyboardPadAction({required this.keyService, required this.keys});

  @override
  Future<void> execute() async {
    keyService.sendCombination(keys);
  }
}
