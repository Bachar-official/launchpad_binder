import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/app/di.dart';
import 'package:launchpad_binder/feature/settings/settings_state.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di.settingsManager;

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
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: state.isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      DropdownButtonFormField<MidiDevice>(
                        decoration: const InputDecoration(
                          helperText: 'Select MIDI device',
                        ),
                        items: state.devices
                            .map(
                              (el) => DropdownMenuItem<MidiDevice>(
                                value: el,
                                child: Text(el.name),
                              ),
                            )
                            .toList(),
                        onChanged: manager.selectDevice,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
