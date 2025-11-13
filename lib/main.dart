import 'package:aandm/screens/home/main_app_screen.dart';
import 'package:blvckleg_dart_core/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerDartCore();
  await Hive.openBox('theme');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MainAppScreen());
}
