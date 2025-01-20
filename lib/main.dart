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
  await Hive.openBox('theme');
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
  ThemeMode? _themeMode;

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
      _themeMode = themeMode;
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
    _themeMode = _getThemeMode();
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
        title: Text("A and M",
            style: Theme.of(context).primaryTextTheme.titleMedium),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TimerPreviewWidget(
            themeMode: MyApp.of(context)!._themeMode!,
            onPressed: () {
              navigateToScreen(context, TimerScreen(), true);
            },
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton.icon(
                onPressed: () {
                  navigateToScreen(context, ToDoListScreen(), true);
                },
                label: Text("To-Do Listen",
                    style: Theme.of(context).primaryTextTheme.titleSmall),
                icon: Icon(
                  Icons.list,
                  color: Theme.of(context).primaryIconTheme.color,
                )),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton.icon(
                onPressed: () {
                  navigateToScreen(context, NotesScreen(), true);
                },
                label: Text(
                  "Notizen",
                  style: Theme.of(context).primaryTextTheme.titleSmall,
                ),
                icon: Icon(
                  Icons.note,
                  color: Theme.of(context).primaryIconTheme.color,
                )),
          ),
        ],
      ),
    );
  }
}
