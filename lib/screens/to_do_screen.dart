import 'package:aandm/models/task.dart';
import 'package:aandm/models/task_list.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key, required this.list});
  final TaskListWithTasks list;
  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<Task> tasks = [];
  String title = 'Titel';
  String content = 'Inhalt';

  @override
  void initState() {
    setState(() {
      tasks = widget.list.tasks;
    });
    super.initState();
  }

  List<Task> getTasks(TaskList list) {
    final box = Hive.box<Task>('tasks');
    return box.values
        .where((element) => element.taskListId == list.id)
        .toList();
  }

  createNewItem(Task data) {
    final box = Hive.box<Task>('tasks');
    box.add(data);
    setState(() {
      tasks.add(data);
    });
  }

  deleteItem(int index) {
    final box = Hive.box<Task>('tasks');
    box.deleteAt(index);
    setState(() {
      tasks = getTasks(widget.list.taskList);
    });
  }

  ListView getAllListItems() {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          "Titel",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          tasks[index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          "Inhalt",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          tasks[index].content,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteItem(index);
                        },
                      ),
                      Transform.scale(
                        scale: 1.75,
                        child: Checkbox(
                          value: tasks[index].isDone,
                          onChanged: (bool? value) {
                            final box = Hive.box<Task>('tasks');
                            final task = box.getAt(index);
                            task!.isDone = value!;
                            box.putAt(index, task);
                            setState(() {
                              tasks = getTasks(widget.list.taskList);
                            });
                          },
                          activeColor: Colors.purple[200],
                          checkColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
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
                        controller: TextEditingController(text: title),
                        onChanged: (value) {
                          title = value;
                        },
                        onTap: () {
                          setState(() {
                            title = '';
                          });
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: TextEditingController(text: content),
                        onChanged: (value) {
                          content = value;
                        },
                        onTap: () {
                          setState(() {
                            content = '';
                          });
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                        onPressed: () {
                          createNewItem(Task(
                              title, content, false, widget.list.taskList.id));
                        },
                        child: const Text("Create new Item")),
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
