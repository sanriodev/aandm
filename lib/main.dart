import 'package:aandm/models/note.dart';
import 'package:aandm/screens/notes_screen.dart';
import 'package:aandm/screens/to_do_list_screen.dart';
import 'package:aandm/ui/theme.dart';
import 'package:aandm/models/task.dart';
import 'package:aandm/models/task_list.dart';
import 'package:aandm/screens/timer_screen.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/timer_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskListAdapter());
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<TaskList>('taskLists');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Note>('notes');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A & M',
      themeMode: _themeMode,
      theme: appThemeLight,
      darkTheme: appThemeDark,
      home: const MyHomePage(title: 'A & M'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("A and M",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Fluttertoast.showToast(msg: "I miss you too darling!");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.settings_brightness),
              onPressed: () {
                if (MyApp.of(context)!._themeMode == ThemeMode.dark) {
                  MyApp.of(context)!._themeMode = ThemeMode.light;
                  setState(() {
                    MyApp.of(context)!.changeTheme(ThemeMode.light);
                  });
                } else {
                  MyApp.of(context)!._themeMode = ThemeMode.dark;
                  setState(() {
                    MyApp.of(context)!.changeTheme(ThemeMode.dark);
                  });
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TimerPreviewWidget(
            onPressed: () {
              navigateToScreen(context, TimerScreen(), true);
            },
          ),
          ElevatedButton.icon(
              onPressed: () {
                navigateToScreen(context, ToDoListScreen(), true);
              },
              label: Text("To-Do Listen"),
              icon: Icon(Icons.list)),
          ElevatedButton.icon(
              onPressed: () {
                navigateToScreen(context, NotesScreen(), true);
              },
              label: Text("Notizen"),
              icon: Icon(Icons.note)),
        ],
      ),
    );
  }
}
