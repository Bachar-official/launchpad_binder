import 'package:flutter/material.dart';
import 'package:launchpad_binder/entity/manager_deps.dart';
import 'package:launchpad_binder/feature/color_dictionary/color_dictionary_manager.dart';
import 'package:launchpad_binder/feature/color_dictionary/color_dictionary_state.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_manager.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:launchpad_binder/feature/settings/settings_manager.dart';
import 'package:launchpad_binder/feature/settings/settings_state.dart';
import 'package:launchpad_binder/service/config_service.dart';
import 'package:launchpad_binder/service/midi_service.dart';
import 'package:logger/logger.dart';

class DI {
  final ManagerDeps deps = (logger: Logger(), scaffoldKey: GlobalKey<ScaffoldMessengerState>(), navKey: GlobalKey<NavigatorState>());
  
  late final MidiService midiService = MidiService();
  late final ConfigService configService = ConfigService();

  late final settingsManager = SettingsManager(SettingsState.initial(), deps: deps, midiService: midiService);
  late final wizardManager = WizardManager(WizardState.initial(), deps: deps, midiService: midiService);
  late final ColorDictionaryManager colorManager = ColorDictionaryManager(ColorDictionaryState.initial(), deps: deps, midiService: midiService);

  void init() {
  }
}

final di = DI();