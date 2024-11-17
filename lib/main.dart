import 'package:aandm/ui/theme.dart';
import 'package:aandm/models/task.dart';
import 'package:aandm/models/task_list.dart';
import 'package:aandm/screens/timer_screen.dart';
import 'package:aandm/screens/to_do_screen.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/task_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskListAdapter());
  await Hive.openBox<TaskList>('taskLists');
  await Hive.openBox<Task>('tasks');
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
  List<TaskListWithTasks> taskLists = [];
  String collectionName = 'Name der Liste';

  @override
  void initState() {
    super.initState();
    getTaskListsAndTasks();
  }

  void getTaskListsAndTasks() {
    final box = Hive.box<TaskList>('taskLists');
    final taskBox = Hive.box<Task>('tasks');
    final List<TaskList> taskLists = box.values.toList();

    final List<TaskListWithTasks> res = [];

    final List<Task> tasks = taskBox.values.toList();

    for (final taskList in taskLists) {
      res.add(TaskListWithTasks(taskList,
          tasks.where((item) => item.taskListId == taskList.id).toList()));
    }
    setState(() {
      this.taskLists = res;
    });
  }

  void createNewItem(TaskList data) {
    final box = Hive.box<TaskList>('taskLists');
    box.add(data);
    setState(() {
      taskLists.add(TaskListWithTasks(data, []));
    });
  }

  void deleteItem(int index) {
    final box = Hive.box<TaskList>('taskLists');
    box.deleteAt(index);
    getTaskListsAndTasks();
  }

  ListView getAllListItems() {
    return ListView.builder(
        itemCount: taskLists.length,
        itemBuilder: (BuildContext context, int index) {
          return TaskListWidget(
              onTap: () {
                navigateToScreen(
                    context,
                    ToDoScreen(
                      list: taskLists[index],
                    ),
                    true);
              },
              onDeletePress: () {
                deleteItem(index);
              },
              taskListName: taskLists[index].taskList.name,
              totalTaks: taskLists[index].tasks.length,
              completedTasks:
                  taskLists[index].tasks.where((test) => test.isDone).length,
              openTasks:
                  taskLists[index].tasks.where((test) => !test.isDone).length);
        });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('listViewVis'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          getTaskListsAndTasks();
        }
      },
      child: Scaffold(
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
                icon: const Icon(Icons.timer_outlined),
                onPressed: () {
                  navigateToScreen(context, const TimerScreen(), true);
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
            Expanded(child: getAllListItems()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          controller:
                              TextEditingController(text: collectionName),
                          onChanged: (value) {
                            collectionName = value;
                          },
                          onTap: () {
                            setState(() {
                              collectionName = '';
                            });
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: ElevatedButton(
                          onPressed: () {
                            final newIncrementedId = _getIncrement(taskLists);
                            createNewItem(TaskList(
                              collectionName,
                              newIncrementedId,
                            ));
                          },
                          child: const Text("Create new List")),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getIncrement(List<TaskListWithTasks> taskLists) {
    var max = 0;
    if (taskLists.isEmpty) {
      return 1;
    }
    for (var i = 0; i < taskLists.length; i++) {
      if (taskLists[i].taskList.id > max) {
        max = taskLists[i].taskList.id;
      }
    }
    return max + 1;
  }
}
