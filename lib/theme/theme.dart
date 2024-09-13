import 'package:flutter/material.dart';

// Defines the light theme for the app.
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300, // The background color of components like cards.
    primary: Colors.grey.shade200, // Main color used in primary UI elements like buttons.
    secondary: Colors.grey.shade400, // Accent color for highlighting UI elements.
    inversePrimary: Colors.grey.shade800, // Color for text/icons displayed on primary elements.
  ),
);

// Defines the dark theme for the app.
ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 24, 24, 24), // Background color for widgets in dark mode.
    primary: const Color.fromARGB(255, 34, 34, 34), // Main color for primary UI elements in dark mode.
    secondary: const Color.fromARGB(255, 49, 49, 49), // Accent color for dark mode UI elements.
    inversePrimary: Colors.grey.shade300, // Text/icon color on primary elements in dark mode.
  ),
);
