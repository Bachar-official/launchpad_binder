import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/app/routing.dart';
import 'package:launchpad_binder/entity/entity.dart';
import 'package:launchpad_binder/feature/settings/components/calibration_dialog.dart';
import 'package:launchpad_binder/feature/settings/settings_state.dart';
import 'package:launchpad_binder/native/key_simulator.dart';
import 'package:launchpad_binder/service/service.dart';
import 'package:launchpad_binder/utils/midi_utils.dart';

class SettingsManager extends ManagerBase<SettingsState>
    with CEHandler, SnackbarMixin, LoggerMixin {
  final MidiService midiService;
  final ConfigService configService;

  SettingsManager(
    super.state, {
    required super.deps,
    required this.midiService,
    required this.configService,
  });

  List<MidiDevice> midiDevices = [];
  bool isInitializedWidget = false;
  MidiDevice? get active => midiService.activeDevice;
  StreamSubscription<MidiPacket>? _pressSubscription;

  void setIsLoading(bool isLoading) => handle((emit) async {
    emit(state.copyWith(isLoading: isLoading));
  });

  void updateDevices() => handle((emit) async {
    debug('Try to get MIDI devices');
    _pressSubscription?.cancel();
    _pressSubscription = null;
    disconnectDevice();
    setIsLoading(true);
    try {
      final devices = await midiService.devices;
      checkCondition(
        devices == null || devices.isEmpty,
        'MIDI devices not found',
      );
      midiDevices = devices!;
      success('Got ${devices.length} devices!');

      final config = await configService.getConfig();
      if (config == null) {
        final result = await showDialog<bool>(
          context: deps.navKey.currentState!.overlay!.context,
          builder: (context) => CalibrationDialog(),
        );
        if (result != null && result) {
          await deps.navKey.currentState!.pushNamed(AppRouter.wizard);
        }
      } else {
        emit(state.copyWith(config: config));
        showSnackbar(
          deps: deps,
          reason: SnackbarReason.success,
          message: 'Device configuration loaded!',
        );
      }
    } catch (e, s) {
      catchException(
        deps: deps,
        exception: e,
        stacktrace: s,
        message: 'Error while getting MIDI devices',
      );
    } finally {
      setIsLoading(false);
    }
  });

  void selectDevice(MidiDevice? device) => handle((emit) async {
    debug('Selecting device ${device?.name}');
    setIsLoading(true);
    try {
      await midiService.connectToDevice(device);
      emit(state.copyWith(connectedDevice: device));
    } catch (e, s) {
      catchException(
        deps: deps,
        exception: e,
        stacktrace: s,
        message: 'Error while connecting to device',
      );
    } finally {
      setIsLoading(false);
    }
    if (midiService.onMidiData != null) {
      final sim = KeySimulator.init();
      _pressSubscription = midiService.onMidiData?.listen((event) async {
        final pad = MidiUtils.getPressedPad(
          event,
          configService.config?.mapping,
        );
        if (pad == Pad.a1) {
          sim.simulateKeyCombo(['ctrl', 'alt', 't']);
        }
        if (pad == Pad.a2) {
          sim.simulateKeyCombo(['alt', 'F4']);
        }
      });
    }
  });

  void disconnectDevice() => handle((emit) async {
    debug('Disconnecting...');
    setIsLoading(true);
    try {
      _pressSubscription?.cancel();
      _pressSubscription = null;
      midiService.disconnect();
      emit(state.copyWith(connectedDevice: null, nullableDevice: true));
    } catch (e, s) {
      catchException(
        deps: deps,
        exception: e,
        stacktrace: s,
        message: 'Error while disconnecting',
      );
    } finally {
      setIsLoading(false);
    }
  });
}
