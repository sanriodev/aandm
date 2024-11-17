import 'package:flutter/material.dart';

ThemeData appThemeLight = ThemeData(
  primaryColor: Colors.blue[200],
  secondaryHeaderColor: Colors.purple[200],
  colorScheme: ColorScheme.fromSwatch(
      accentColor: Colors.purple, backgroundColor: Colors.white38),
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
  cardTheme: const CardTheme(
    color: Colors.white,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.purple[400],
  ),
  iconTheme: IconThemeData(color: Colors.purple[400]),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black26, width: 2.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black45, width: 2.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black26, width: 2.5),
    ),
  ),
);

ThemeData appThemeDark = ThemeData(
  primaryColor: Colors.blue[900],
  secondaryHeaderColor: Colors.purple[800],
  colorScheme: ColorScheme.fromSwatch(
      accentColor: Colors.purple[800], backgroundColor: Colors.white10),
  scaffoldBackgroundColor: Colors.blue[800],
  textTheme: const TextTheme(
    displayMedium: TextStyle(color: Colors.black87),
    displayLarge: TextStyle(color: Colors.black54),
    displaySmall: TextStyle(color: Colors.black54),
  ),
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.purple[800],
    backgroundColor: Colors.purple[800],
    titleTextStyle: const TextStyle(color: Colors.black),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue[800],
    textTheme: ButtonTextTheme.primary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.purple[800],
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.purple[700],
  ),
  iconTheme: IconThemeData(color: Colors.purple[800]),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(Size(200, 40)),
    backgroundColor: WidgetStatePropertyAll(Colors.purple[800]),
    foregroundColor: const WidgetStatePropertyAll(Colors.white),
    textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 16)),
  )),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
      backgroundColor: WidgetStatePropertyAll(Colors.purple[600]),
    ),
  ),
  cardTheme: const CardTheme(
    color: Colors.black,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white24, width: 2.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white54, width: 2.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white24, width: 2.5),
    ),
    labelStyle: TextStyle(color: Colors.white),
  ),
);
