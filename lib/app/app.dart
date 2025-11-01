import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/routing.dart';
import 'package:launchpad_binder/app/scope.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => ScopeBuilder<AppScopeContainer>(
    builder: (ctx, scope) => MaterialApp(
      onGenerateRoute: AppRouter.onGenerateRoute,
      scaffoldMessengerKey: scope?.deps.get.scaffoldKey,
      navigatorKey: scope?.deps.get.navKey,
    ),
  );
}
