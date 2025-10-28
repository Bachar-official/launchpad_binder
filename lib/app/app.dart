import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/routing.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(onGenerateRoute: AppRouter.onGenerateRoute);
}
