import 'package:flutter/material.dart';
import 'theme.dart';

class ThemeProvider with ChangeNotifier {
  // Initially, the app starts in light mode.
  ThemeData _themeData = lightMode;

  // Getter to access the current theme (light or dark) from other parts of the app.
  ThemeData get themeData => _themeData;

  // Getter to check if the current theme is dark mode.
  bool get isDarkMode => _themeData == darkMode;

  // Setter to update the theme and notify listeners about the change.
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Notifies the UI to rebuild with the new theme.
  }

  // Toggles between light and dark mode. This will be used in the settings page.
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode; // Switch to dark mode.
    } else {
      themeData = lightMode; // Switch to light mode.
    }
  }
}
