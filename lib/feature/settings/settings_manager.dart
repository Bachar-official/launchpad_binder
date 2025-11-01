import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/app/routing.dart';
import 'package:launchpad_binder/entity/entity.dart';
import 'package:launchpad_binder/feature/settings/components/calibration_dialog.dart';
import 'package:launchpad_binder/feature/settings/settings_state.dart';
import 'package:launchpad_binder/service/service.dart';

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

  void setIsLoading(bool isLoading) => handle((emit) async {
    emit(state.copyWith(isLoading: isLoading));
  });

  void updateDevices() => handle((emit) async {
    debug('Try to get MIDI devices');
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
    // if (midiService.onMidiData != null) {
    //   await for (var packet in midiService.onMidiData!) {
    //     debug(packet.data.toString());
    //   }
    // }
  });

  void disconnectDevice() => handle((emit) async {
    debug('Disconnecting...');
    setIsLoading(true);
    try {
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
