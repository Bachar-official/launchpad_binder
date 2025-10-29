import 'package:flutter/material.dart';

class ColorCard extends StatelessWidget {
  final int velocity;
  final int hexColor;
  final void Function(int) onRemove;
  const ColorCard({
    super.key,
    required this.hexColor,
    required this.onRemove,
    required this.velocity,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Container(color: Color(hexColor)),
      label: Text(velocity.toString()),
      deleteIcon: const Icon(Icons.clear),
      onDeleted: () => onRemove(velocity),
    );
  }
}
