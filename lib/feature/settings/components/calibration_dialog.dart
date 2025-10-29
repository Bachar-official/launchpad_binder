import 'package:flutter/material.dart';

class CalibrationDialog extends StatelessWidget {
  const CalibrationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Device calibration'),
      content: const Text(
        'Looks like your Launchpad isn\'t calibrated. Would you like to do it?',
      ),
      actions: [
        TextButton(
          child: const Text('Yes'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        TextButton(
          child: const Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
