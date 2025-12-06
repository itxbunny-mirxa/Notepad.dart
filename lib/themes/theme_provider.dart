import 'package:flutter/material.dart';
import 'package:notebook/themes/theme.dart';

class ThemeProvider with ChangeNotifier {
  // initial theme mode is light mode
  ThemeData _themeData = lightMode;

  // getter method to access current theme
  ThemeData get themeData => _themeData;

  // check if current mode is dark
  bool get isDarkMode => _themeData == darkMode;

  // setter - update theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); 
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
