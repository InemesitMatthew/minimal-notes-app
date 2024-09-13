import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

class ThemeProvider with ChangeNotifier {
  // Initially, theme is light mode
  ThemeData _themeData = lightMode;

  // Constructor to load theme preference on app startup
  ThemeProvider() {
    _loadTheme();
  }

  // Getter method to access the theme from other parts of the code
  ThemeData get themeData => _themeData;

  // Getter method to see if we are in dark mode or not
  bool get isDarkMode => _themeData == darkMode;

  // Setter method to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
    _saveTheme(); // Save the theme preference when changed
  }

  // Toggle between light and dark mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  // Load the saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDark ? darkMode : lightMode;
    notifyListeners(); // Notify UI about the loaded theme
  }

  // Save the current theme to SharedPreferences
  Future<void> _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }
}
