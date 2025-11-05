import 'package:flutter/material.dart';

class ColorDictionaryState {
  final bool isLoading;
  // Key is MIDI velocity, value is HEX color
  final Map<int, int> colorMap;
  final int velocity;
  final Color color;

  const ColorDictionaryState({
    required this.isLoading,
    required this.colorMap,
    required this.velocity,
    required this.color,
  });

  const ColorDictionaryState.initial()
    : isLoading = false,
      colorMap = const <int, int>{}, velocity = 0, color = const Color(0xFF000000);

  ColorDictionaryState withNewColor({
    required int colorVelocity,
    required int hexColor,
  }) {
    final MapEntry<int, int> newColor = MapEntry(colorVelocity, hexColor);
    final newColorMap = Map<int, int>.from(colorMap);
    newColorMap.addEntries([newColor]);
    return copyWith(colorMap: newColorMap);
  }

  ColorDictionaryState withoutVelocity(int colorVelocity) {
    final newMap = Map<int, int>.from(colorMap);
    newMap.remove(colorVelocity);
    return copyWith(colorMap: newMap);
  }

  ColorDictionaryState copyWithVelocity({required int velocity, required int hexColor}) {
    final newColorMap = Map<int, int>.from(colorMap);
    newColorMap[velocity] = hexColor;
    return copyWith(colorMap: newColorMap);
  }

  ColorDictionaryState copyWith({
    bool? isLoading,
    Map<int, int>? colorMap,
    int? velocity,
    Color? color,
  }) => ColorDictionaryState(
    isLoading: isLoading ?? this.isLoading,
    colorMap: colorMap ?? this.colorMap,
    velocity: velocity ?? this.velocity,
    color: color ?? this.color,
  );
}
