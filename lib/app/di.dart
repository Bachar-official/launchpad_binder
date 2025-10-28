import 'package:flutter/material.dart';
import 'package:launchpad_binder/entity/manager_deps.dart';
import 'package:launchpad_binder/feature/settings/settings_manager.dart';
import 'package:launchpad_binder/feature/settings/settings_state.dart';
import 'package:logger/logger.dart';

class DI {
  final ManagerDeps deps = (logger: Logger(), scaffoldKey: GlobalKey<ScaffoldMessengerState>());
  late final settingsManager = SettingsManager(SettingsState.initial(), deps: deps);

  void init() {
    settingsManager.updateDevices();
  }
}

final di = DI();