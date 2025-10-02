import 'package:aandm/adapter/login_auth_adapter.dart';
import 'package:aandm/backend/settings/settings.dart';
import 'package:aandm/models/base/login_response_model.dart';
import 'package:aandm/screens/home/main_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(LoginAuthAdapter());
  await Hive.openBox<LoginResponse>('auth');
  await Hive.openBox('theme');
  final settings = Settings();
  await settings.loadSettings();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MainAppScreen());
}
