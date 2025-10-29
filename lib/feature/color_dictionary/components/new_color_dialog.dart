import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:launchpad_binder/app/di.dart';
import 'package:launchpad_binder/components/count_selector.dart';
import 'package:launchpad_binder/entity/enum/pad.dart';

class NewColorDialog extends StatefulWidget {
  const NewColorDialog({super.key});

  @override
  State<NewColorDialog> createState() => _NewColorDialogState();
}

class _NewColorDialogState extends State<NewColorDialog> {
  final manager = di.colorManager;
  int currentVelocity = 0;
  Color chosenColor = Color(0x00000000);

  @override
  void initState() {
    super.initState();
    manager.sendVelocity(Pad.a1, currentVelocity);
  }

  void setChosenColor(Color color) {
    chosenColor = color;
    setState(() {});
  }

  void setVelocity(double velocity) {
    currentVelocity = velocity.toInt();
    manager.sendVelocity(Pad.a1, currentVelocity);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add color to dictionary'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Choose desired velocity value and then pick a similar color.'),
          CountSelector(
            value: currentVelocity.toDouble(),
            min: 0.0,
            max: 127.0,
            onChanged: setVelocity,
          ),
          ColorPicker(pickerColor: chosenColor, onColorChanged: setChosenColor),
        ],
      ),
      actions: [
        TextButton(onPressed: () {
          manager.sendVelocity(Pad.a1, 0);
          Navigator.of(context).pop((currentVelocity, chosenColor.toARGB32()));
        }, child: const Text('Add')),
        TextButton(onPressed: () {
          manager.sendVelocity(Pad.a1, 0);
          Navigator.of(context).pop(null);
        }, child: const Text('Cancel')),
      ],
    );
  }
}