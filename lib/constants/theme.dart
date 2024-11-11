import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  primaryColor: Colors.blue[200],
  secondaryHeaderColor: Colors.purple[200],
  colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      accentColor: Colors.purple,
      backgroundColor: Colors.white38),
  scaffoldBackgroundColor: Colors.blue[100],
  textTheme: const TextTheme(
    displayMedium: TextStyle(color: Colors.black87),
    displayLarge: TextStyle(color: Colors.black54),
    displaySmall: TextStyle(color: Colors.black54),
  ),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.red,
    backgroundColor: Colors.red,
    titleTextStyle: TextStyle(color: Colors.black),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue[200],
    textTheme: ButtonTextTheme.primary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.purple[200],
  ),
);
