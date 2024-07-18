import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isLight) {
    _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
