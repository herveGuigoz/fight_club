import 'package:flutter/material.dart';

/// A service that stores and retrieves user settings.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local storage.
  ThemeMode themeMode() => ThemeMode.system;

  /// Persists the user's preferred ThemeMode to local storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // todo Use the shared_preferences package to persist settings locally.
  }
}
