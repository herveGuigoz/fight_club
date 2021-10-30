import 'package:fight_club/src/core/storage/hydrated_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const kSettingsStorageKey = '_settings_';

final settingsProvider = StateNotifierProvider<SettingsController, ThemeMode>(
  (ref) => SettingsController(),
);

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
class SettingsController extends SettingsService {
  void updateThemeMode(ThemeMode? newThemeMode) {
    if (newThemeMode == null || newThemeMode == state) return;
    state = newThemeMode;
  }
}

/// A service that stores and retrieves user settings.
abstract class SettingsService extends HydratedStateNotifier<ThemeMode> {
  SettingsService() : super(ThemeMode.system);

  /// Loads the User's preferred ThemeMode from local storage.
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    switch (json[kSettingsStorageKey] as String?) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
    }
  }

  /// Persists the user's preferred ThemeMode to local storage.
  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {kSettingsStorageKey: state.convertToString()};
  }
}

extension on ThemeMode {
  String convertToString() => toString().split('.')[1];
}
