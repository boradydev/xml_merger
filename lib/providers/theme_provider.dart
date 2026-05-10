import 'package:flutter/material.dart';
import '../core/theme.dart'; // Импортируем ваши настройки

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeData get lightTheme => AppTheme.createTheme(Brightness.light);

  ThemeData get darkTheme => AppTheme.createTheme(Brightness.dark);

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}
