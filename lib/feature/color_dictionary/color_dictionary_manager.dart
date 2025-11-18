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

  bool isInitializedWidget = false;

  void setIsLoading(bool isLoading) =>
      handle((emit) async => emit(state.copyWith(isLoading: isLoading)));

  void addPair(int velocity, int color) => handle(
    (emit) async =>
        emit(state.withNewColor(colorVelocity: velocity, hexColor: color)),
  );

  void editPair(int velocity, int color) => handle(
    (emit) async =>
        emit(state.copyWithVelocity(velocity: velocity, hexColor: color)),
  );

  void readMapping() => handle((emit) async {
    debug('Trying to read mapping');
    setIsLoading(true);
    try {
      final mapping = await configService.getDictionary();
      if (mapping != null) {
        emit(state.copyWith(colorMap: mapping));
        success('Got mapping with ${mapping.length} records');
        showSnackbar(
          deps: deps,
          reason: SnackbarReason.success,
          message: 'Got color dictionary!',
        );
      }
    } catch (e, s) {
      catchException(
        deps: deps,
        exception: e,
        stacktrace: s,
        message: 'Error while reading mappings',
      );
    } finally {
      setIsLoading(false);
    }
  });

  Future<void> saveMapping() async {
    debug('Trying to save mapping');
    setIsLoading(true);
    try {
      await configService.saveDictionary(state.colorMap);
      success('Mapping saved!');
      showSnackbar(
        deps: deps,
        reason: SnackbarReason.success,
        message: 'Dictionary saved successfully!',
      );
    } catch (e, s) {
      catchException(
        deps: deps,
        exception: e,
        stacktrace: s,
        message: 'Error while saving mappings',
      );
    } finally {
      setIsLoading(false);
    }
  }

  void removePair(int velocity) =>
      handle((emit) async => emit(state.withoutVelocity(velocity)));

  void setVelocity(double velocity) => handle((emit) async {
    sendVelocity(Pad.a1, velocity.toInt());
    emit(state.copyWith(velocity: velocity.toInt()));
  });

  void setColor(Color color) =>
      handle((emit) async => emit(state.copyWith(color: color)));

  Future<void> onAddPair() async {
    final newPair = await showDialog<(int, int)>(
      context: deps.navKey.currentState!.overlay!.context,
      builder: (ctx) => NewColorDialog(isEdit: false),
    );
    if (newPair != null) {
      addPair(newPair.$1, newPair.$2);
      setVelocity(0);
    }
  }

  Future<void> onEditPair(int velocity, int hexColor) async {
    setColor(Color(hexColor));
    setVelocity(velocity.toDouble());
    final editedPair = await showDialog<(int, int)>(
      context: deps.navKey.currentState!.overlay!.context,
      builder: (ctx) => NewColorDialog(isEdit: true),
    );
    if (editedPair != null) {
      editPair(editedPair.$1, editedPair.$2);
      setVelocity(0);
    }
  }

  Future<void> sendVelocity(Pad pad, int velocity) async {
    try {
      checkCondition(configService.config == null, 'Device config not found');
      final midiPad = configService.config!.mapping[pad];
      checkCondition(midiPad == null, 'mapping not found');
      midiService.send([midiPad!.type, midiPad.address, velocity]);
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
