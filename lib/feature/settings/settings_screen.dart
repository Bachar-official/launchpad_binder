import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/app/routing.dart';
import 'package:launchpad_binder/app/scope.dart';
import 'package:launchpad_binder/components/launchpad_visualizer.dart';
import 'package:launchpad_binder/entity/enum/pad.dart';
import 'package:launchpad_binder/feature/settings/settings_state.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<AppScopeContainer>.withPlaceholder(
      builder: (ctx, scope) {
        final manager = scope.settingsManager.get;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!manager.isInitializedWidget) {
            manager.updateDevices();
            manager.isInitializedWidget = true;
          }
        });

        return StateBuilder<SettingsState>(
          stateReadable: manager,
          builder: (context, state, _) => Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              actions: [
                IconButton(
                  onPressed: manager.updateDevices,
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRouter.wizard),
                  icon: const Icon(Icons.settings),
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRouter.colors),
                  icon: const Icon(Icons.colorize),
                  tooltip: 'Open color dictionary',
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<MidiDevice>(
                          decoration: InputDecoration(
                            helperText: 'Select MIDI device',
                            suffix: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: manager.disconnectDevice,
                            ),
                          ),
                          items: manager.midiDevices
                              .map(
                                (el) => DropdownMenuItem<MidiDevice>(
                                  value: el,
                                  child: Text(el.name),
                                ),
                              )
                              .toList(),
                          onChanged: manager.selectDevice,
                        ),
                        Expanded(
                          child: LaunchpadVisualizer(highlightedPads: {}),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
