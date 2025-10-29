import 'package:launchpad_binder/entity/device_config.dart';

class SettingsState {
  final bool isLoading;
  final DeviceConfig? config;

  SettingsState({required this.isLoading, required this.config});

  SettingsState.initial() : isLoading = false, config = null;

  SettingsState copyWith({
    bool? isLoading,
    DeviceConfig? config,
    bool nullableConfig = false,
  }) => SettingsState(
    isLoading: isLoading ?? this.isLoading,
    config: nullableConfig ? null : config ?? this.config,
  );
}
