import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/app/di.dart';
import 'package:launchpad_binder/app/routing.dart';
import 'package:launchpad_binder/entity/enum/snackbar_reason.dart';
import 'package:launchpad_binder/entity/interface/manager_base.dart';
import 'package:launchpad_binder/entity/mixin/logger_mixin.dart';
import 'package:launchpad_binder/feature/settings/components/calibration_dialog.dart';
import 'package:launchpad_binder/feature/settings/settings_state.dart';
import 'package:launchpad_binder/entity/mixin/condition_exception_handler.dart';
import 'package:launchpad_binder/entity/mixin/snackbar_mixin.dart';
import 'package:launchpad_binder/service/midi_service.dart';

class SettingsManager extends ManagerBase<SettingsState>
    with CEHandler, SnackbarMixin, LoggerMixin {
  final MidiService midiService;

  SettingsManager(
    super.state, {
    required super.deps,
    required this.midiService,
  });

  List<MidiDevice> midiDevices = [];
  bool isInitializedWidget = false;
  MidiDevice? get active => midiService.activeDevice;

  void setIsLoading(bool isLoading) => handle((emit) async {
    emit(state.copyWith(isLoading: isLoading));
  });

  void updateDevices() => handle((emit) async {
    debug('Try to get MIDI devices');
    selectDevice(null);
    setIsLoading(true);
    try {
      final devices = await midiService.devices;
      checkCondition(
        devices == null || devices.isEmpty,
        'MIDI devices not found',
      );
      midiDevices = devices!;
      success('Got ${devices.length} devices!');

      final config = await di.configService.getConfig();
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
    await midiService.connectToDevice(device);
    if (midiService.onMidiData != null) {
      await for (var packet in midiService.onMidiData!) {
        debug(packet.data.toString());
      }
    }
  });

  void disconnectDevice() async {
    debug('Disconnecting device ${active?.name}...');
    try {
      await midiService.disconnect();
    } catch(e, s) {
      catchException(deps: deps, exception: e, stacktrace: s, message: 'Error while disconnecting');
    }
  }
}
