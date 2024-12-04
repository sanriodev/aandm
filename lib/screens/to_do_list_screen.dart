import 'package:aandm/models/task.dart';
import 'package:aandm/models/task_list.dart';
import 'package:aandm/screens/to_do_screen.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/task_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
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
    final taskToDelete = taskLists[index];
    deleteItemsForList(taskToDelete.taskList.id);
    box.deleteAt(index);
    getTaskListsAndTasks();
  }

  void deleteItemsForList(int taskListId) {
    final box = Hive.box<Task>('tasks');
    final itemsToDelete = box.values
        .where((element) => element.taskListId == taskListId)
        .toList();
    box.deleteAll(itemsToDelete.map((e) => e.key).toList());
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
          title: const Text("To-Do Listen",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.black,
              tooltip: "I love my gf",
            ),
          ),
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
                          style: const TextStyle(color: Colors.grey),
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
                            final List<TaskList> taskListEntities =
                                taskLists.map((e) => e.taskList).toList();
                            final newIncrementedId =
                                getIncrement<TaskList>(taskListEntities);
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
}