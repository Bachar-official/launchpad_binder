import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/di.dart';
import 'package:launchpad_binder/entity/enum/palette.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

class SelectPaletteStep extends StatelessWidget {
  const SelectPaletteStep({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di.wizardManager;
    return StateBuilder<WizardState>(
      stateReadable: manager,
      builder: (context, state, _) => DropdownButtonFormField<Palette>(
        decoration: const InputDecoration(
          labelText: 'Select palette',
        ),
        items: Palette.values
            .map((el) => DropdownMenuItem(value: el, child: Text(el.value)))
            .toList(),
        onChanged: manager.setPalette,
      ),
    );
  }
}
