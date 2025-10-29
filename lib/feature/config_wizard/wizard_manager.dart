import 'dart:async';

import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/entity/enum/palette.dart';
import 'package:launchpad_binder/entity/enum/pad.dart';
import 'package:launchpad_binder/entity/enum/snackbar_reason.dart';
import 'package:launchpad_binder/entity/interface/manager_base.dart';
import 'package:launchpad_binder/entity/mixin/condition_exception_handler.dart';
import 'package:launchpad_binder/entity/mixin/logger_mixin.dart';
import 'package:launchpad_binder/entity/mixin/snackbar_mixin.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:launchpad_binder/service/midi_service.dart';

class WizardManager extends ManagerBase<WizardState>
    with CEHandler, SnackbarMixin, LoggerMixin {
  WizardManager(super.state, {required super.deps, required this.midiService}) {
    updateDevices();
  }

  final MidiService midiService;
  StreamSubscription<MidiPacket>? _singlePressSubscription;

  void setStep(int step) => handle((emit) async => emit(state.copyWith(step: step)));

  void setPalette(Palette? palette) => handle((emit) async => emit(state.copyWith(palette: palette, step: 2)));

  void updateDevices() => handle((emit) async {
    debug('Try to get MIDI devices');
    try {
      final devices = await midiService.devices;
      checkCondition(devices == null || devices.isEmpty, 'MIDI devices not found');
      emit(state.copyWith(devices: devices));
      success('Got ${devices?.length} devices!');
    } catch (e, s) {
      catchException(
        deps: deps,
        exception: e,
        stacktrace: s,
        message: 'Error while getting MIDI devices',
      );
    }
  });

  void selectDevice(MidiDevice? device) => handle((emit) async {
    debug('Selecting device ${device?.name}');
    await midiService.connectToDevice(device);
    if (device != null) setStep(1);
  });

  // === КАЛИБРОВКА ===

  void startFullMapping() => handle((emit) async {
    // Начинаем с первой кнопки
    emit(state.copyWith(currentMappingPad: Pad.values[0]));
    _listenForNextPad();
  });

  void _listenForNextPad() {
    _singlePressSubscription?.cancel();
    _singlePressSubscription = midiService.onMidiData?.listen((packet) {
      if (_isNoteOn(packet)) {
        _onPadPressed(packet.data[1]);
      }
    });
  }

  void _onPadPressed(int midiNote) {
    final currentPad = state.currentMappingPad;
    if (currentPad == null) return;

    // Сохраняем
    final newMap = Map<Pad, int>.from(state.profileMap);
    newMap[currentPad] = midiNote;

    // Определяем следующую кнопку
    final currentIndex = Pad.values.indexOf(currentPad);
    final isLast = currentIndex == Pad.values.length - 1;
    final nextPad = isLast ? null : Pad.values[currentIndex + 1];

    handle((emit) async {
      if (nextPad != null) {
        // Продолжаем
        emit(state.copyWith(profileMap: newMap, currentMappingPad: nextPad));
        success('Button "${currentPad.name}" → $midiNote');
      } else {
        // Завершаем
        _singlePressSubscription?.cancel();
        _singlePressSubscription = null;
        emit(state.copyWith(profileMap: newMap, currentMappingPad: null));
        success('Calibration completed!');
        showSnackbar(deps: deps, reason: SnackbarReason.success, message: 'Calibration completed!');
        deps.navKey.currentState!.pop();
      }
    });
  }

  bool _isNoteOn(MidiPacket packet) {
    if (packet.data.length < 3) return false;
    final status = packet.data[0];
    final velocity = packet.data[2];
    return (status & 0xF0) > 0x0 && velocity > 0;
  }

  void cancelMapping() {
    _singlePressSubscription?.cancel();
    _singlePressSubscription = null;
    handle((emit) async => emit(state.copyWith(currentMappingPad: null)));
  }
}