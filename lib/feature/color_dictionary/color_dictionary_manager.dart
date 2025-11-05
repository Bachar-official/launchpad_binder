import 'package:flutter/material.dart';
import 'package:launchpad_binder/entity/entity.dart';
import 'package:launchpad_binder/feature/color_dictionary/color_dictionary_state.dart';
import 'package:launchpad_binder/feature/color_dictionary/components/new_color_dialog.dart';
import 'package:launchpad_binder/service/service.dart';

class ColorDictionaryManager extends ManagerBase<ColorDictionaryState>
    with CEHandler, SnackbarMixin, LoggerMixin {
  final MidiService midiService;
  final ConfigService configService;

  ColorDictionaryManager(
    super.state, {
    required super.deps,
    required this.midiService,
    required this.configService,
  });

  void setIsLoading(bool isLoading) =>
      handle((emit) async => emit(state.copyWith(isLoading: isLoading)));

  void addPair(int velocity, int color) => handle(
    (emit) async =>
        emit(state.withNewColor(colorVelocity: velocity, hexColor: color)),
  );

  void removePair(int velocity) =>
      handle((emit) async => emit(state.withoutVelocity(velocity)));

  void setVelocity(double velocity) => handle((emit) async {
    sendVelocity(Pad.a1, velocity.toInt());
    emit(state.copyWith(velocity: velocity.toInt()));
  });

  void setColor(Color color) => handle((emit) async => emit(state.copyWith(color: color)));

  Future<void> onAddPair() async {
    final newPair = await showDialog<(int, int)>(
      context: deps.navKey.currentState!.overlay!.context,
      builder: (ctx) => NewColorDialog(),
    );
    if (newPair != null) {
      addPair(newPair.$1, newPair.$2);
      setVelocity(0);
    }
  }

  Future<void> sendVelocity(Pad pad, int velocity) async {
    try {
      checkCondition(
        configService.configNotifier.value == null,
        'Device config not found',
      );
      final midiPad = configService.configNotifier.value!.mapping[pad];
      checkCondition(midiPad == null, 'mapping not found');
      midiService.sendMidi(type: midiPad!.type, address: midiPad.address, velocity: velocity);
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
