import 'package:aandm/constants/theme.dart';
import 'package:aandm/models/task.dart';
import 'package:aandm/models/task_list.dart';
import 'package:aandm/screens/timer_screen.dart';
import 'package:aandm/screens/to_do_screen.dart';
import 'package:aandm/util/helpers.dart';
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
  await Hive.openBox<TaskList>('taskLists');
  await Hive.openBox<Task>('tasks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A & M',
      theme: appTheme,
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
  List<TaskList> taskLists = [];
  String collectionName = 'Name der Liste';

  @override
  void initState() {
    super.initState();
    taskLists = getTaskLists();
  }

  List<TaskList> getTaskLists() {
    final box = Hive.box<TaskList>('taskLists');
    return box.values.toList();
  }

  createNewItem(TaskList data) {
    final box = Hive.box<TaskList>('taskLists');
    box.add(data);
    setState(() {
      taskLists.add(data);
    });
  }

  deleteItem(int index) {
    final box = Hive.box<TaskList>('taskLists');
    box.deleteAt(index);
    setState(() {
      taskLists = getTaskLists();
    });
  }

  ListView getAllListItems() {
    return ListView.builder(
        itemCount: taskLists.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              navigateToScreen(
                  context,
                  ToDoScreen(
                    list: taskLists[index],
                  ),
                  true);
            },
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            taskLists[index].name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                right: 10,
                              ),
                              child: Text(
                                  "Anzahl: ${taskLists[index].tasks?.length}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                  "fertig: ${taskLists[index].tasks?.where((item) => item.isDone).length}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                  "offen: ${taskLists[index].tasks?.where((item) => !item.isDone).length}"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteItem(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("A and M",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Fluttertoast.showToast(msg: "I miss you too darling!");
              },
              color: Colors.black,
              tooltip: "I love my gf",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.timer_outlined),
              onPressed: () {
                navigateToScreen(context, const TimerScreen(), true);
              },
              color: Colors.black,
              tooltip: "I love my gf",
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: getAllListItems()),
          Divider(
            thickness: 4,
            color: Colors.blue[200],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: TextEditingController(text: collectionName),
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
                          createNewItem(TaskList(
                            collectionName,
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
    );
  }
}
