import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/di.dart';
import 'package:launchpad_binder/feature/config_wizard/steps/select_device.dart';
import 'package:launchpad_binder/feature/config_wizard/steps/select_palette.dart';
import 'package:launchpad_binder/feature/config_wizard/steps/select_profile_buttons.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

class WizardScreen extends StatelessWidget {
  const WizardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di.wizardManager;
    return StateBuilder<WizardState>(
      stateReadable: manager,
      builder: (context, state, _) => Scaffold(
        body: Stepper(
          currentStep: state.step,
          controlsBuilder: (context, details) => SizedBox.shrink(),
          steps: <Step>[
            Step(
              title: const Text('Choose your controller'),
              content: SelectDeviceStep(),
              isActive: state.step == 0,
            ),
            Step(
              title: const Text('Choose palette'),
              content: SelectPaletteStep(),
              isActive: manager.midiService.activeDevice != null,
            ),
            Step(
              title: const Text('Let\'s bind profile buttons'),
              content: SelectProfileButtonsStep(),
              isActive: state.step == 2,
            ),
        ]),
      ),
    );
  }
}