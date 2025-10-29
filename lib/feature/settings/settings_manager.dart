import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/entity/interface/manager_base.dart';
import 'package:launchpad_binder/entity/mixin/logger_mixin.dart';
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
}
