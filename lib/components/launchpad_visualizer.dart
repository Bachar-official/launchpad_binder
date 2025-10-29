import 'dart:math';

import 'package:flutter/material.dart';
import 'package:launchpad_binder/entity/enum/pad.dart';

class LaunchpadVisualizer extends StatelessWidget {
  final Set<Pad> highlightedPads;
  final void Function(Pad pad)? onPadTap;

  const LaunchpadVisualizer({
    super.key,
    this.highlightedPads = const {},
    this.onPadTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 9, // почти квадрат, но с правой колонкой
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = min(constraints.maxWidth / 9, constraints.maxHeight / 9);

          // Список всех падов в порядке визуального расположения
          final List<Pad?> layout = [
            // Верхняя строка
            Pad.up,
            Pad.down,
            Pad.left,
            Pad.right,
            Pad.session,
            Pad.user1,
            Pad.user2,
            Pad.mixer,
            null, // пустая ячейка справа сверху (там ничего нет)
            // 8 строк матрицы + правый столбец
            for (int row = 0; row < 8; row++) ...[
              for (int col = 0; col < 8; col++)
                Pad.values[Pad.values.indexOf(Pad.a1) + row * 8 + col],
              Pad.values[Pad.values.indexOf(Pad.a) + row], // правая колонка
            ],
          ];

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: layout.length,
            itemBuilder: (context, index) {
              final pad = layout[index];
              if (pad == null) {
                return const SizedBox.shrink();
              }
              final isHighlighted = highlightedPads.contains(pad);
              final isProfile = [
                Pad.a,
                Pad.b,
                Pad.c,
                Pad.d,
                Pad.e,
                Pad.f,
                Pad.g,
                Pad.h
              ].contains(pad);
              final isTop = [
                Pad.up,
                Pad.down,
                Pad.left,
                Pad.right,
                Pad.session,
                Pad.user1,
                Pad.user2,
                Pad.mixer
              ].contains(pad);

              final baseColor = isProfile || isTop
                  ? Colors.grey[700]!
                  : const Color.fromARGB(255, 182, 182, 182);

              return GestureDetector(
                onTap: onPadTap != null ? () => onPadTap!(pad) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: cellSize,
                  height: cellSize,
                  decoration: BoxDecoration(
                    color: isHighlighted ? Colors.blueAccent : baseColor,
                    borderRadius: BorderRadius.circular(
                      isProfile || isTop ? cellSize / 2 : cellSize * 0.1,
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: isHighlighted ? 2 : 1,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
