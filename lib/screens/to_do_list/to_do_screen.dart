import 'package:aandm/backend/service/backend_service.dart';
import 'package:aandm/models/task/dto/create_task_dto.dart';
import 'package:aandm/models/task/task_api_model.dart';
import 'package:aandm/models/tasklist/task_list_api_model.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:aandm/widgets/skeleton/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key, required this.list});
  final TaskList list;
  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<Task> tasks = [];
  String title = 'Titel';
  String content = 'Inhalt';
  bool isLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getTasksForList();
  }

  Future<void> getTasksForList() async {
    final backend = Backend();
    final res = await backend.getAllTasksForList(widget.list.id);
    setState(() {
      tasks = res;
      isLoading = false;
    });
  }

  Future<void> createNewItem(CreateTaskDto data) async {
    final backend = Backend();
    await backend.createTask(data);
    await backend.getAllTasks();
  }

  void deleteItem(int index) {
    final box = Hive.box<Task>('tasks');
    box.deleteAt(index);
    setState(() {
      tasks = widget.list.tasks;
    });
  }

  ListView getAllListItems() {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: Text("Titel",
                            style:
                                Theme.of(context).primaryTextTheme.titleSmall),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(tasks[index].title,
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text("Inhalt",
                            style:
                                Theme.of(context).primaryTextTheme.titleSmall),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(tasks[index].content ?? '',
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium),
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
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).iconTheme.color),
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
                              tasks = widget.list.tasks;
                            });
                          },
                          activeColor: Colors.purple[200],
                          checkColor: Colors.grey[200],
                          side:
                              const BorderSide(color: Colors.grey, width: 1.5),
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
    return VisibilityDetector(
        key: const Key('listViewToDoItemsVis'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0) {
            getTasksForList();
          }
        },
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("To-Do List",
                  style: Theme.of(context).primaryTextTheme.titleMedium),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Theme.of(context).primaryIconTheme.color,
                  tooltip: "I love my gf",
                ),
              ),
              actions: [
                IconButton(
                  color: Theme.of(context).primaryIconTheme.color,
                  icon: const PhosphorIcon(
                    PhosphorIconsRegular.gear,
                    semanticLabel: 'Einstellungen',
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
              ],
            ),
            endDrawer: AppDrawer(),
            body: RefreshIndicator(
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              onRefresh: () async {
                setState(() {
                  isLoading = true;
                });
                return await getTasksForList();
              },
              child: Column(
                children: <Widget>[
                  if (isLoading)
                    Skeletonizer(
                        effect: ShimmerEffect(
                          baseColor: Theme.of(context).canvasColor,
                          duration: const Duration(seconds: 3),
                        ),
                        enabled: isLoading,
                        child: const SkeletonCard()),
                  Expanded(child: !isLoading ? getAllListItems() : Container()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextField(
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyMedium,
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
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyMedium,
                                controller:
                                    TextEditingController(text: content),
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
                                createNewItem(CreateTaskDto(
                                    title: title,
                                    content: content,
                                    taskListId: widget.list.id));
                              },
                              child: Text("Neuer Eintrag",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .titleSmall),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
