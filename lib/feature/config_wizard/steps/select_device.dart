import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/scope.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

class SelectDeviceStep extends StatelessWidget {
  const SelectDeviceStep({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<AppScopeContainer>.withPlaceholder(
      builder: (ctx, scope) {
        final manager = scope.wizardManager.get;
        return StateBuilder<WizardState>(
          stateReadable: manager,
          builder: (context, state, _) => Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    helperText: 'Controller',
                    hintText: 'Select controller',
                  ),
                  items: state.devices
                      .map(
                        (el) =>
                            DropdownMenuItem(value: el, child: Text(el.name)),
                      )
                      .toList(),
                  onChanged: manager.selectDevice,
                ),
              ),
              IconButton(
                onPressed: manager.updateDevices,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        );
      },
    );
  }
}
