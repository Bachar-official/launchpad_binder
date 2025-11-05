import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:launchpad_binder/app/scope.dart';
import 'package:launchpad_binder/components/count_selector.dart';
import 'package:launchpad_binder/entity/enum/pad.dart';
import 'package:launchpad_binder/feature/color_dictionary/color_dictionary_state.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

class NewColorDialog extends StatelessWidget {
  final bool isEdit;
  const NewColorDialog({super.key, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<AppScopeContainer>.withPlaceholder(
      builder: (ctx, scope) {
        final manager = scope.colorManager.get;
        return StateBuilder<ColorDictionaryState>(
          stateReadable: manager,
          builder: (ctx, state, _) => AlertDialog(
            title: Text('${isEdit ? 'Edit' : 'Add'} dictionary color'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Choose desired velocity value and then pick a similar color.',
                ),
                CountSelector(
                  disabled: isEdit,
                  value: state.velocity.toDouble(),
                  min: 0.0,
                  max: 127.0,
                  onChanged: manager.setVelocity,
                  displayFunction: (value) => value.toStringAsFixed(0),
                ),
                ColorPicker(
                  pickerColor: state.color,
                  onColorChanged: manager.setColor,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  manager.sendVelocity(Pad.a1, 0);
                  Navigator.of(
                    context,
                  ).pop((state.velocity, state.color.toARGB32()));
                },
                child: Text(isEdit ? 'Edit' : 'Add'),
              ),
              TextButton(
                onPressed: () {
                  manager.sendVelocity(Pad.a1, 0);
                  Navigator.of(context).pop(null);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}
