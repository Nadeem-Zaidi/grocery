import 'package:flutter/material.dart';

final ThemeData myAppTheme = ThemeData(
  // Color scheme
  colorScheme: ColorScheme.light(
    primary: Colors.deepPurple, // Primary color
    secondary: Colors.amber, // Background color
    surface: Colors.grey[200]!, // Surface color (e.g., cards, dialogs)
    error: Colors.red, // Error color
    onPrimary: Colors.white, // Text/icon color on primary color
    onSecondary: Colors.black, // Text/icon color on background color
    onSurface: Colors.black, // Text/icon color on surface color
    onError: Colors.white, // Text/icon color on error color
  ),

  // Typography
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  ),

  // Button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple, // Button background color
      foregroundColor: Colors.white, // Button text color
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Button border radius
      ),
    ),
  ),

  // Input decoration theme (for TextFormField)
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // Input field border radius
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red),
    ),
  ),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple, // AppBar background color
    foregroundColor: Colors.white, // AppBar text/icon color
    elevation: 4, // AppBar shadow
  ),

  // Card theme
  cardTheme: CardTheme(
    elevation: 2, // Card shadow
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Card border radius
    ),
  ),

  // Other customizations
  useMaterial3: true, // Enable Material 3 design (optional)
);
