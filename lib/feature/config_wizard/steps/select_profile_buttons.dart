import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/di.dart';
import 'package:launchpad_binder/components/launchpad_visualizer.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

class SelectProfileButtonsStep extends StatelessWidget {
  const SelectProfileButtonsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di.wizardManager;
    return StateBuilder<WizardState>(
      stateReadable: manager,
      builder: (ctx, state, _) {
        if (state.step == 2 && state.currentMappingPad == null) {
          manager.startFullMapping();
        }
        
        return LaunchpadVisualizer(
        highlightedPad: state.currentMappingPad,
      );
      },
    );
  }
}
