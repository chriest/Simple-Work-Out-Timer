import 'package:swot/colors.dart';
import 'package:flutter/material.dart';

ThemeData swotLight = ThemeData.light(useMaterial3: true).copyWith(
  colorScheme: ThemeData.light(useMaterial3: true).colorScheme.copyWith(
    brightness: Brightness.light,
    primary: mainL, 
    secondary: contrastL,
    tertiary: buttonStdL,
    surface: mainRed,
    scrim: secondL,
    primaryContainer: seriNumL,
  ),
  /*canvasColor: mainL,
  secondaryHeaderColor: contrastL,
  hintColor: buttonStdL,
  highlightColor: mainRed,*/
  scaffoldBackgroundColor: mainL,
  textSelectionTheme: const TextSelectionThemeData (selectionColor: greenGo)
);

ThemeData swotDark = ThemeData.dark(useMaterial3: true).copyWith(
  colorScheme: ThemeData.dark(useMaterial3: true).colorScheme.copyWith(
    brightness: Brightness.dark,
    primary: mainD,
    secondary: contrastD,
    tertiary: buttonStdD,
    surface: mainRed,
    scrim: secondD,
    primaryContainer: seriNumD,
  ),
  /*canvasColor: mainD,
  secondaryHeaderColor: contrastD,
  hintColor: buttonStdD,
  highlightColor: mainRed,*/
  scaffoldBackgroundColor: mainD,
  textSelectionTheme: const TextSelectionThemeData (selectionColor: ocraTwo)
);

