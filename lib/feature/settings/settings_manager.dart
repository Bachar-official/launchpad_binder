import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/entity/interface/manager_base.dart';
import 'package:launchpad_binder/entity/mixin/logger_mixin.dart';
import 'package:launchpad_binder/feature/settings/settings_state.dart';
import 'package:launchpad_binder/entity/mixin/condition_exception_handler.dart';
import 'package:launchpad_binder/entity/mixin/snackbar_mixin.dart';

class SettingsManager extends ManagerBase<SettingsState>
    with CEHandler, SnackbarMixin, LoggerMixin {
  SettingsManager(super.state, {required super.deps});

  void setIsLoading(bool isLoading) => handle((emit) async {
    emit(state.copyWith(isLoading: isLoading));
  });

  void updateDevices() => handle((emit) async {
    debug('Try to get MIDI devices');
    selectDevice(null);
    setIsLoading(true);
    try {
      final devices = await MidiCommand().devices;
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
    } finally {
      setIsLoading(false);
    }
  });

  void selectDevice(MidiDevice? device) => handle((emit) async {
    debug('Selecting device ${device?.name}');
    emit(state.copyWith(activeDevice: device, nullableDevice: device == null));
  });
}
