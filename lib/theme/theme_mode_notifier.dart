import 'package:flutter/material.dart';

/// Tema modunu (system / light / dark) tutar ve dinlenebilir hale getirir.
class ThemeModeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void set(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  /// system → light → dark → system döngüsü.
  void cycle() {
    switch (_mode) {
      case ThemeMode.system:
        _mode = ThemeMode.light;
        break;
      case ThemeMode.light:
        _mode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _mode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }
}
