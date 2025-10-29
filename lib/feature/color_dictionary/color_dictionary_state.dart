class ColorDictionaryState {
  final bool isLoading;
  // Key is MIDI velocity, value is HEX color
  final Map<int, int> colorMap;

  const ColorDictionaryState({
    required this.isLoading,
    required this.colorMap,
  });

  const ColorDictionaryState.initial()
    : isLoading = false,
      colorMap = const <int, int>{};

  ColorDictionaryState withNewColor({
    required int velocity,
    required int hexColor,
  }) {
    final MapEntry<int, int> newColor = MapEntry(velocity, hexColor);
    final newColorMap = Map<int, int>.from(colorMap);
    newColorMap.addEntries([newColor]);
    return copyWith(colorMap: newColorMap);
  }

  ColorDictionaryState withoutVelocity(int velocity) {
    final newMap = Map<int, int>.from(colorMap);
    newMap.remove(velocity);
    return copyWith(colorMap: newMap);
  }

  ColorDictionaryState copyWith({
    bool? isLoading,
    Map<int, int>? colorMap,
  }) => ColorDictionaryState(
    isLoading: isLoading ?? this.isLoading,
    colorMap: colorMap ?? this.colorMap,
  );
}
