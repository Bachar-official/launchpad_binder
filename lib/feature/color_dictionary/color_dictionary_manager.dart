import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/di.dart';
import 'package:launchpad_binder/entity/entity.dart';
import 'package:launchpad_binder/feature/color_dictionary/color_dictionary_state.dart';
import 'package:launchpad_binder/feature/color_dictionary/components/new_color_dialog.dart';
import 'package:launchpad_binder/service/midi_service.dart';

class ColorDictionaryManager extends ManagerBase<ColorDictionaryState>
    with CEHandler, SnackbarMixin, LoggerMixin {
  final MidiService midiService;
  ColorDictionaryManager(
    super.state, {
    required super.deps,
    required this.midiService,
  });

  void setIsLoading(bool isLoading) =>
      handle((emit) async => emit(state.copyWith(isLoading: isLoading)));

  void addPair(int velocity, int color) => handle(
    (emit) async =>
        emit(state.withNewColor(velocity: velocity, hexColor: color)),
  );

  void removePair(int velocity) =>
      handle((emit) async => emit(state.withoutVelocity(velocity)));

  Future<void> onAddPair() async {
    final newPair = await showDialog<(int, int)>(context: deps.navKey.currentState!.overlay!.context, builder: (ctx) => NewColorDialog());
    if (newPair != null) {
      addPair(newPair.$1, newPair.$2);
    }
  }

  Future<void> sendVelocity(Pad pad, int velocity) async {
    try {
      checkCondition(di.settingsManager.state.config == null, 'Device config not found');
      final address = di.settingsManager.state.config!.mapping[pad];
      midiService.sendMidi(address!, velocity);
    } catch (e, s) {
      catchException(
        deps: deps,
        exception: e,
        stacktrace: s,
        message: 'Error while sending velocity',
      );
    }
  }
}
