import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/scope.dart';
import 'package:launchpad_binder/components/launchpad_visualizer.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

class CalibratePadsStep extends StatelessWidget {
  const CalibratePadsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<AppScopeContainer>.withPlaceholder(
      builder: (ctx, scope) {
        final manager = scope.wizardManager.get;
        return StateBuilder<WizardState>(
          stateReadable: manager,
          builder: (ctx, state, _) {
            if (state.step == 1 && state.currentMappingPad == null) {
              manager.startFullMapping();
            }

            return SizedBox(
              height: 300,
              child: LaunchpadVisualizer(
                highlightedPads: state.currentMappingPad == null
                    ? {}
                    : {state.currentMappingPad!},
              ),
            );
          },
        );
      },
    );
  }
}
