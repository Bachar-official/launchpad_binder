import 'package:launchpad_binder/feature/color_dictionary/color_dictionary_manager.dart';
import 'package:launchpad_binder/feature/color_dictionary/color_dictionary_state.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_manager.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:launchpad_binder/feature/settings/settings_manager.dart';
import 'package:launchpad_binder/feature/settings/settings_state.dart';
import 'package:launchpad_binder/service/service.dart';
import 'package:yx_scope/yx_scope.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

class AppScopeContainer extends ScopeContainer {
  late final deps = dep(() => (logger: Logger(), scaffoldKey: GlobalKey<ScaffoldMessengerState>(), navKey: GlobalKey<NavigatorState>()));

  late final midiService = dep(() => MidiService());
  late final configService = dep(() => ConfigService());

  late final settingsManager = dep(() => SettingsManager(SettingsState.initial(), deps: deps.get, midiService: midiService.get, configService: configService.get));
  late final wizardManager = dep(() => WizardManager(WizardState.initial(), deps: deps.get, midiService: midiService.get, configService: configService.get));
  late final colorManager = dep(() => ColorDictionaryManager(ColorDictionaryState.initial(), deps: deps.get, midiService: midiService.get, configService: configService.get));
}

class AppScopeHolder extends ScopeHolder<AppScopeContainer> {
  @override
  AppScopeContainer createContainer() => AppScopeContainer();
}