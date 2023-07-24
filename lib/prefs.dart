import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  ///This will get called at initial and check the theme you've currently stored. and update the theme initially.
  ThemeProvider() {
    getThemeAtInit();
  }

  
  getThemeAtInit() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isDarkTheme =
        sharedPreferences.getBool("is_dark");
    if (isDarkTheme != null && isDarkTheme!) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
      }
      notifyListeners();
    }

  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme() async{
        themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
        notifyListeners();
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setBool("is_dark", themeMode == ThemeMode.dark);
      }
}