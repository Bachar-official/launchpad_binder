import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/app.dart';
import 'package:launchpad_binder/app/scope.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appScopeHolder = AppScopeHolder();
  await appScopeHolder.create();  
  runApp(ScopeProvider<AppScopeContainer>(holder: appScopeHolder, child: const App()));
}
