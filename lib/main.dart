import 'package:aandm/adapter/login_auth_adapter.dart';
import 'package:aandm/backend/settings/settings.dart';
import 'package:aandm/models/auth/login_response_model.dart';
import 'package:aandm/models/note.dart';
import 'package:aandm/screens/home/main_app_screen.dart';
import 'package:aandm/models/task.dart';
import 'package:aandm/models/task_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskListAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(LoginAuthAdapter());
  await Hive.openBox<LoginResponse>('auth');
  await Hive.openBox<TaskList>('taskLists');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Note>('notes');
  await Hive.openBox('theme');
  final settings = Settings();
  await settings.loadSettings();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MainAppScreen());
}
