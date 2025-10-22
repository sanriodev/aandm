import 'package:aandm/backend/service/cat_backend_service.dart';
import 'package:aandm/routes/routes.dart';
import 'package:aandm/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  late final GoRouter _router;

  void changeTheme(ThemeMode themeMode) {
    final themeBox = Hive.box('theme');
    if (themeMode == ThemeMode.light) {
      themeBox.put('theme', 'light');
    } else if (themeMode == ThemeMode.dark) {
      themeBox.put('theme', 'dark');
    } else {
      themeBox.put('theme', 'light');
    }
    setState(() {
      currentTheme = themeMode;
    });
  }

  ThemeMode _getThemeMode() {
    final theme = Hive.box('theme');
    if (theme.get('theme') == null) {
      theme.put('theme', 'light');
      return ThemeMode.light;
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
    _router = createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider(create: (context) => CatBackend())],
      child: MaterialApp.router(
        title: 'Alina\'s App',
        themeMode: currentTheme,
        theme: appThemeLight,
        darkTheme: appThemeDark,
        routerConfig: _router,
      ),
    );
  }
}
