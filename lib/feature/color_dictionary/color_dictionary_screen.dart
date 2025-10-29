import 'package:flutter/material.dart';
import 'package:launchpad_binder/app/di.dart';
import 'package:launchpad_binder/feature/color_dictionary/color_dictionary_state.dart';
import 'package:launchpad_binder/feature/color_dictionary/components/color_card.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

class ColorDictionaryScreen extends StatelessWidget {
  const ColorDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di.colorManager;
    return StateBuilder<ColorDictionaryState>(
      stateReadable: manager,
      builder: (context, state, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Color dictionary'),
          actions: [
            IconButton(
              onPressed: manager.onAddPair,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Wrap(
              children: state.colorMap.entries
                  .map(
                    (el) => ColorCard(
                      hexColor: el.value,
                      onRemove: manager.removePair,
                      velocity: el.key,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
