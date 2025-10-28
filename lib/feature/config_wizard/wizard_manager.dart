import 'dart:async';

import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/entity/enum/palette.dart';
import 'package:launchpad_binder/entity/enum/profile_pad.dart';
import 'package:launchpad_binder/entity/interface/manager_base.dart';
import 'package:launchpad_binder/entity/mixin/condition_exception_handler.dart';
import 'package:launchpad_binder/entity/mixin/logger_mixin.dart';
import 'package:launchpad_binder/entity/mixin/snackbar_mixin.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:launchpad_binder/service/midi_service.dart';

class WizardManager extends ManagerBase<WizardState>
    with CEHandler, SnackbarMixin, LoggerMixin {
  WizardManager(super.state, {required super.deps, required this.midiService});
  final MidiService midiService;
  List<MidiDevice> devices = [];
  StreamSubscription<MidiPacket>? _singlePressSubscription;

  void setStep(int step) => handle((emit) async {
    emit(state.copyWith(step: step));
  });

  void setPalette(Palette? palette) => handle((emit) async {
    emit(state.copyWith(palette: palette));
  });

  void updateDevices() => handle((emit) async {
    debug('Try to get MIDI devices');
    selectDevice(null);
    try {
      final response = await midiService.devices;
      checkCondition(
        response == null || response.isEmpty,
        'MIDI devices not found',
      );
      devices = response!;
      success('Got ${devices.length} devices!');
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
    if (midiService.onMidiData != null) {
      await for (var packet in midiService.onMidiData!) {
        debug(packet.data.toString());
      }
    }
  });

  void cancelCurrentMapping() async {
    await _singlePressSubscription?.cancel();
    _singlePressSubscription = null;
    handle((emit) async => emit(state.copyWith(currentMappingPad: null)));
  }

  void _handleSinglePadPress(ProfilePad pad, int midiNote) async {
    // Отменяем подписку сразу после первого нажатия
    await _singlePressSubscription?.cancel();
    _singlePressSubscription = null;

    // Сохраняем
    handle((emit) async {
      final newMap = Map<ProfilePad, int>.from(state.profileMap);
      newMap[pad] = midiNote;
      emit(
        state.copyWith(
          profileMap: newMap,
          currentMappingPad: null, // снимаем подсветку
        ),
      );
    });

    success('Кнопка "${pad.name}" сопоставлена с MIDI note $midiNote');
  }

  bool _isNoteOn(MidiPacket packet) {
    if (packet.data.length < 3) return false;
    final status = packet.data[0];
    final velocity = packet.data[2];
    return (status & 0xF0) == 0x90 && velocity > 0;
  }

  void startMappingFor(ProfilePad pad) => handle((emit) async {
    // Подсвечиваем кнопку в UI
    emit(state.copyWith(currentMappingPad: pad));

    // Отменяем предыдущую подписку (на всякий случай)
    await _singlePressSubscription?.cancel();

    // Подписываемся на одно нажатие
    _singlePressSubscription = midiService.onMidiData?.listen((packet) {
      if (_isNoteOn(packet)) {
        _handleSinglePadPress(pad, packet.data[1]);
      }
    });
  });
}
