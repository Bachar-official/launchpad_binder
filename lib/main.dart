import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/app.dart';
import 'package:launchpad_binder/app/di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const App());
}