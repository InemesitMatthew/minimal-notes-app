import 'package:flutter/material.dart';

// Defines the light theme for the app.
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface:  Colors.grey.shade300, // The surface color for widgets such as cards.
    primary: Colors.grey.shade200, // The primary color, used for primary widgets like buttons.
    secondary: Colors.grey.shade400, // The secondary color, typically used for accenting elements.
    inversePrimary: Colors.grey.shade800, // The inverse of the primary color, used for contrast.
  ),
);

// Defines the dark theme for the app.
ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface:const Color.fromARGB(255, 24, 24, 24), // The surface color for widgets such as cards.
    primary: const Color.fromARGB(255, 34, 34, 34), // The primary color, used for primary widgets like buttons.
    secondary: const Color.fromARGB(255, 49, 49, 49), // The secondary color, typically used for accenting elements.
    inversePrimary: Colors.grey.shade300, // The inverse of the primary color, used for contrast.
  ),
);
