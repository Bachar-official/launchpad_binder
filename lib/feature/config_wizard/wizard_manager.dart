import 'dart:async';

import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/entity/entity.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:launchpad_binder/service/service.dart';

class WizardManager extends ManagerBase<WizardState>
    with CEHandler, SnackbarMixin, LoggerMixin {

  final ConfigService configService;
  final MidiService midiService;

  WizardManager(
    super.state, {
    required super.deps,
    required this.midiService,
    required this.configService,
  }) {
    updateDevices();
  }

  StreamSubscription<MidiPacket>? _singlePressSubscription;

  void setDeviceId(String? deviceId) => handle(
    (emit) async => emit(
      state.copyWith(deviceId: deviceId, nullableDeviceId: deviceId == null),
    ),
  );

  void setStep(int step) =>
      handle((emit) async => emit(state.copyWith(step: step)));

  void updateDevices() => handle((emit) async {
    debug('Try to get MIDI devices');
    try {
      final devices = await midiService.devices;
      checkCondition(
        devices == null || devices.isEmpty,
        'MIDI devices not found',
      );
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
    setDeviceId(device?.id);
    await midiService.connectToDevice(device);
    if (device != null) setStep(1);
  });

  // === CALIBRATION ===

  void startFullMapping() => handle((emit) async {
    // Begin from first pad
    emit(state.copyWith(currentMappingPad: Pad.values[0]));
    _listenForNextPad();
  });

  void _listenForNextPad() {
    _singlePressSubscription?.cancel();
    _singlePressSubscription = midiService.onMidiData?.listen((packet) {
      if (_isNoteOn(packet)) {
        _onPadPressed(packet.data[0], packet.data[1]);
      }
    });
  }

  void _onPadPressed(int type, int address) {
    final currentPad = state.currentMappingPad;
    if (currentPad == null) return;

    // Save
    final newMap = Map<Pad, MidiPad>.from(state.mapping);
    newMap[currentPad] = MidiPad(address: address, type: type);

    // Define next button
    final currentIndex = Pad.values.indexOf(currentPad);
    final isLast = currentIndex == Pad.values.length - 1;
    final nextPad = isLast ? null : Pad.values[currentIndex + 1];

    handle((emit) async {
      if (nextPad != null) {
        // Send maximum velocity signal
        midiService.sendMidi(type: type, address: address, velocity: 127);
        // Continue
        emit(state.copyWith(profileMap: newMap, currentMappingPad: nextPad));
        success('Button "${currentPad.name}" → $address');
      } else {
        // End
        midiService.clearMidi();
        _singlePressSubscription?.cancel();
        _singlePressSubscription = null;
        emit(state.copyWith(profileMap: newMap, currentMappingPad: null));
        success('Calibration completed!');
        midiService.disconnect();
        try {
          await configService.saveConfig(state.toConfig());
          showSnackbar(
            deps: deps,
            reason: SnackbarReason.success,
            message: 'Calibration completed!',
          );
          // di.settingsManager.updateDevices();
          deps.navKey.currentState!.pop();
        } catch (e, s) {
          catchException(
            deps: deps,
            exception: e,
            stacktrace: s,
            message: 'Error while saving config',
          );
        }
      }
    });
  }

  bool _isNoteOn(MidiPacket packet) {
    if (packet.data.length < 3) return false;
    final velocity = packet.data[2];
    return velocity > 0;
  }

  void cancelMapping() {
    _singlePressSubscription?.cancel();
    _singlePressSubscription = null;
    handle((emit) async => emit(state.copyWith(currentMappingPad: null)));
  }
}
