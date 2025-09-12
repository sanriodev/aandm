import 'package:aandm/backend/service/backend_service.dart';
import 'package:aandm/screens/home/home_screen.dart';
import 'package:aandm/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();

  static _MainAppScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppScreenState>();
}

class _MainAppScreenState extends State<MainAppScreen> {
  ThemeMode? currentTheme;

  void changeTheme(ThemeMode themeMode) {
    final themeBox = Hive.box('theme');
    if (themeMode == ThemeMode.light) {
      themeBox.put('theme', 'light');
    } else if (themeMode == ThemeMode.dark) {
      themeBox.put('theme', 'dark');
    } else {
      themeBox.put('theme', 'system');
    }
    setState(() {
      currentTheme = themeMode;
    });
  }

  ThemeMode _getThemeMode() {
    final theme = Hive.box('theme');
    if (theme.get('theme') == null) {
      theme.put('theme', 'system');
      return ThemeMode.system;
    }
    if (theme.get('theme') == 'light') {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }

  @override
  void initState() {
    super.initState();
    currentTheme = _getThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [Provider(create: (context) => Backend())],
        child: MaterialApp(
          title: 'A & M',
          themeMode: currentTheme,
          theme: appThemeLight,
          darkTheme: appThemeDark,
          home: const HomeScreen(title: 'A & M'),
        ));
  }
}
