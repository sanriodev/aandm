import 'package:aandm/backend/backend_service.dart';
import 'package:aandm/models/cat_facts_api_model.dart';
import 'package:aandm/models/cat_picture_api_model.dart';
import 'package:aandm/models/note.dart';
import 'package:aandm/screens/notes_screen.dart';
import 'package:aandm/screens/to_do_list_screen.dart';
import 'package:aandm/ui/theme.dart';
import 'package:aandm/models/task.dart';
import 'package:aandm/models/task_list.dart';
import 'package:aandm/screens/timer_screen.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:aandm/widgets/cat_facts_widget.dart';
import 'package:aandm/widgets/notes_preview_widget.dart';
import 'package:aandm/widgets/timer_preview_widget.dart';
import 'package:aandm/widgets/to_do_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

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
          home: const MyHomePage(title: 'A & M'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CatFactsApiModel> catFacts = [];
  List<CatPictureApiModel> catPictures = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getCatData();
    super.initState();
  }

  Future<void> getCatData() async {
    final backend = Provider.of<Backend>(context, listen: false);
    try {
      final pictures = await backend.getCatPictures();
      setState(() {
        catPictures = pictures;
      });
    } catch (e) {
      print(e);
    }
    try {
      final facts = await backend.getCatFacts();
      setState(() {
        catFacts = facts;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("A and M",
              style: Theme.of(context).primaryTextTheme.titleMedium),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.favorite),
                color: Theme.of(context).primaryIconTheme.color,
                onPressed: () {
                  Fluttertoast.showToast(msg: "I miss you too darling!");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                color: Theme.of(context).primaryIconTheme.color,
                icon: const PhosphorIcon(
                  PhosphorIconsRegular.gear,
                  semanticLabel: 'Einstellungen',
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            )
          ],
        ),
        endDrawer: AppDrawer(),
        body: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            onRefresh: () {
              return getCatData();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TimerPreviewWidget(
                    themeMode: MyApp.of(context)!.currentTheme!,
                    onPressed: () {
                      navigateToScreen(context, TimerScreen(), true);
                    },
                  ),
                  TodoPreviewWidget(
                    themeMode: MyApp.of(context)!.currentTheme!,
                    onPressed: () {
                      navigateToScreen(context, ToDoListScreen(), true);
                    },
                  ),
                  NotesPreviewWidget(
                      themeMode: MyApp.of(context)!.currentTheme!,
                      onPressed: () {
                        navigateToScreen(context, NotesScreen(), true);
                      }),
                  CatPreviewWidget(
                      catFacts: catFacts, catPictures: catPictures),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            )));
  }
}
