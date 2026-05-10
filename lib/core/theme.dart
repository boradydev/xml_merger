import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData createTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: brightness,
      ),
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    );
  }
}
