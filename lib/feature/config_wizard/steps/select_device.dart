import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/di.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

class SelectDeviceStep extends StatelessWidget {
  const SelectDeviceStep({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di.wizardManager;

    return StateBuilder<WizardState>(
      stateReadable: manager,
      builder: (context, state, _) => DropdownButtonFormField(
        decoration: InputDecoration(
          helperText: 'Controller',
          prefix: IconButton(onPressed: manager.updateDevices, icon: const Icon(Icons.refresh)),
        ),
        items: manager.devices
            .map((el) => DropdownMenuItem(value: el, child: Text(el.name)))
            .toList(),
        onChanged: manager.selectDevice,
      ),
    );
  }
}
