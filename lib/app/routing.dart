import 'package:flutter/material.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_screen.dart';
import 'package:launchpad_binder/feature/settings/settings_screen.dart';

class AppRouter {
  static const home = '/';
  static const wizard = '/wizard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {
      case home: return _buildRoute((ctx) => SettingsScreen(), settings);
      case wizard: return _buildRoute((ctx) => WizardScreen(), settings);
      default: throw Exception('Invalid route: ${settings.name}');
    }
  }
}

MaterialPageRoute _buildRoute(WidgetBuilder builder, RouteSettings settings) =>
    MaterialPageRoute(builder: builder, settings: settings);
