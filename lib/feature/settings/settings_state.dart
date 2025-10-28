class SettingsState {
  final bool isLoading;

  SettingsState({required this.isLoading});

  SettingsState.initial() : isLoading = false;

  SettingsState copyWith({
    bool? isLoading,
  }) => SettingsState(
    isLoading: isLoading ?? this.isLoading,
  );
}
