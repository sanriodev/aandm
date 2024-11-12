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
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.purple[200],
    backgroundColor: Colors.purple[200],
    titleTextStyle: const TextStyle(color: Colors.black),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue[200],
    textTheme: ButtonTextTheme.primary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.purple[200],
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(Size(200, 40)),
    backgroundColor: WidgetStatePropertyAll(Colors.purple[200]),
    foregroundColor: const WidgetStatePropertyAll(Colors.black),
    textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 16)),
  )),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const WidgetStatePropertyAll(Colors.black),
      backgroundColor: WidgetStatePropertyAll(Colors.purple[100]),
    ),
  ),
);
