import 'package:flutter/material.dart';

class ColorCard extends StatelessWidget {
  final int velocity;
  final int hexColor;
  final void Function(int) onRemove;
  final void Function() onClick;
  const ColorCard({
    super.key,
    required this.hexColor,
    required this.onRemove,
    required this.velocity,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Chip(
        avatar: Container(color: Color(hexColor)),
        label: Text(velocity.toString()),
        deleteIcon: const Icon(Icons.clear),
        onDeleted: () => onRemove(velocity),
      ),
    );
  }
}
