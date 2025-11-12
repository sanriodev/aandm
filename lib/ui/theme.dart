import 'package:flutter/material.dart';

/// Theme extension providing a 5-level activity heatmap color scale
/// (index 0 = no activity, 1..4 increasing intensity).
/// Added so widgets like `ActivityGraphWidget` can obtain consistent
/// colors for light & dark mode without hardcoding color values.
class ActivityHeatmapColors extends ThemeExtension<ActivityHeatmapColors> {
  final List<Color> levels; // length 5

  const ActivityHeatmapColors({required this.levels})
      : assert(levels.length == 5);

  // Light mode scale inspired by GitHub contribution greens but aligned slightly
  // with existing blue/purple brand by nudging hue towards teal.
  factory ActivityHeatmapColors.light() => ActivityHeatmapColors(levels: [
        Color(0xFFE0E0E0), // empty - light grey
        Colors.purple[100]!, // low
        Colors.purple[200]!, // medium
        Colors.purple[300]!, // high
        Colors.purple[400]!, // very high
      ]);

  // Dark mode scale – darker bases with higher contrast.
  factory ActivityHeatmapColors.dark() => ActivityHeatmapColors(levels: [
        Color(0xFF424242), // empty - dark grey
        Colors.purple[800]!, // low
        Colors.purple[700]!, // medium
        Colors.purple[600]!, // high
        Colors.purple[500]!, // very high
      ]);

  @override
  ActivityHeatmapColors copyWith({List<Color>? levels}) {
    return ActivityHeatmapColors(levels: levels ?? this.levels);
  }

  @override
  ThemeExtension<ActivityHeatmapColors> lerp(
      covariant ThemeExtension<ActivityHeatmapColors>? other, double t) {
    if (other is! ActivityHeatmapColors) return this;
    return ActivityHeatmapColors(
      levels: List.generate(
          levels.length, (i) => Color.lerp(levels[i], other.levels[i], t)!),
    );
  }
}

ThemeData appThemeLight = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[200]!),
  primaryColor: Colors.blue[200],
  canvasColor: Colors.grey[400],
  secondaryHeaderColor: Colors.purple[200],
  scaffoldBackgroundColor: Colors.blue[100],
  extensions: <ThemeExtension<dynamic>>[
    ActivityHeatmapColors.light(),
  ],
  appBarTheme: AppBarThemeData(
    foregroundColor: Colors.purple[200],
    backgroundColor: Colors.purple[200],
    titleTextStyle: const TextStyle(color: Colors.black),
  ),
  primaryTextTheme: textThemeLight(),
  textTheme: textThemeLight(),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue[200],
    textTheme: ButtonTextTheme.primary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.purple[200],
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    // minimumSize: const WidgetStatePropertyAll(Size(200, 40)),
    backgroundColor: WidgetStatePropertyAll(Colors.purple[200]),
    foregroundColor: const WidgetStatePropertyAll(Colors.black),
    textStyle: const WidgetStatePropertyAll(
      TextStyle(fontSize: 16, color: Colors.black),
    ),
  )),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const WidgetStatePropertyAll(Colors.black),
      backgroundColor: WidgetStatePropertyAll(Colors.purple[100]),
    ),
  ),
  cardColor: Colors.grey[200],
  cardTheme: const CardThemeData(
    color: Colors.white,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.purple[400],
  ),
  iconTheme: IconThemeData(color: Colors.purple[400]),
  primaryIconTheme: IconThemeData(color: Colors.black),
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
  dialogTheme: DialogThemeData(backgroundColor: Colors.white),
);

ThemeData appThemeDark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue[900]!,
      brightness: Brightness.dark,
    ),
    primaryColor: Colors.blue[900],
    canvasColor: Colors.grey[800],
    secondaryHeaderColor: Colors.purple[800],
    scaffoldBackgroundColor: Colors.blue[800],
    extensions: <ThemeExtension<dynamic>>[
      ActivityHeatmapColors.dark(),
    ],
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.purple[800],
      backgroundColor: Colors.purple[800],
      titleTextStyle: const TextStyle(color: Colors.white),
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
    iconTheme: IconThemeData(
      color: Colors.purple[800],
    ),
    primaryIconTheme: IconThemeData(color: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      // minimumSize: const WidgetStatePropertyAll(Size(200, 40)),
      backgroundColor: WidgetStatePropertyAll(Colors.purple[800]),
      foregroundColor: const WidgetStatePropertyAll(Colors.black),
      textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 16, color: Colors.black)),
    )),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        backgroundColor: WidgetStatePropertyAll(Colors.purple[600]),
      ),
    ),
    cardTheme: const CardThemeData(
      color: Colors.black,
    ),
    cardColor: Colors.black,
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
    primaryTextTheme: textThemeDark(),
    textTheme: textThemeDark(),
    dialogTheme: DialogThemeData(backgroundColor: Colors.black));

TextTheme textThemeLight() {
  return TextTheme(
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 23,
      height: 1.2,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: Colors.black,
      fontSize: 20,
      height: 1.1,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    displayLarge: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: Colors.black,
      fontSize: 12,
    ),
    displaySmall: TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    labelSmall: TextStyle(color: Colors.black, fontSize: 12),
  );
}

TextTheme textThemeDark() {
  return TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 23,
      height: 1.2,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 20,
      height: 1.1,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    labelSmall: TextStyle(color: Colors.white, fontSize: 12),
  );
}
