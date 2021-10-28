import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_service.dart';

final settingsProvider = StateNotifierProvider<SettingsController, ThemeMode>(
  (ref) => SettingsController(SettingsService()),
);

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
class SettingsController extends StateNotifier<ThemeMode> {
  SettingsController(this._settingsService)
      : super(_settingsService.themeMode());

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newThemeMode == state) return;

    // Otherwise, store the new theme mode in memory
    state = newThemeMode;

    // Persist the changes to a local database.
    await _settingsService.updateThemeMode(newThemeMode);
  }
}
