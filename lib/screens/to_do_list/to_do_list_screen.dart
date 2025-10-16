// ignore_for_file: use_build_context_synchronously

import 'package:aandm/backend/service/auth_backend_service.dart';
import 'package:aandm/backend/service/backend_service.dart';
import 'package:aandm/models/exception/session_expired.dart';
import 'package:aandm/models/tasklist/task_list_api_model.dart';
import 'package:aandm/models/tasklist/dto/create_task_list_dto.dart';
import 'package:aandm/screens/to_do_list/to_do_screen.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:aandm/widgets/skeleton/skeleton_card.dart';
import 'package:aandm/widgets/task_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<TaskList> ownTaskLists = [];
  List<TaskList> sharedTaskLists = [];
  String collectionName = 'Name der Liste';
  bool isLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getTaskLists();
  }

  Future<void> getTaskLists() async {
    try {
      final backend = Backend();
      final res = await backend.getAllTaskLists();
      final own = res
          .where((element) =>
              element.user!.username ==
              AuthBackend().loggedInUser?.user?.username)
          .toList();
      final shared = res
          .where((element) =>
              element.user!.username !=
              AuthBackend().loggedInUser?.user?.username)
          .toList();
      setState(() {
        ownTaskLists = own;
        sharedTaskLists = shared;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is SessionExpiredException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte melde dich erneut an.')),
        );

        await deleteBoxAndNavigateToLogin(context);
      }
    }
  }

  Future<void> createNewItem(CreateTaskListDto data) async {
    try {
      final backend = Backend();
      await backend.createTaskList(data);
      await getTaskLists();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is SessionExpiredException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte melde dich erneut an.')),
        );

        await deleteBoxAndNavigateToLogin(context);
      }
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      final backend = Backend();
      await backend.deleteTaskList(id);
      await getTaskLists();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is SessionExpiredException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte melde dich erneut an.')),
        );

        await deleteBoxAndNavigateToLogin(context);
      }
    }
  }

  ListView getAllListItems(List<TaskList> taskLists) {
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
                deleteItem(taskLists[index].id);
              },
              taskListName: taskLists[index].name,
              totalTaks: taskLists[index].tasks.length,
              completedTasks:
                  taskLists[index].tasks.where((test) => test.isDone).length,
              openTasks:
                  taskLists[index].tasks.where((test) => !test.isDone).length,
              author: taskLists[index].user,
              lastModifiedUser: taskLists[index].lastModifiedUser);
        });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('listViewVis'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          getTaskLists();
        }
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("To-Do Listen",
                style: Theme.of(context).primaryTextTheme.titleMedium),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
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
              return await getTaskLists();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (isLoading)
                  Skeletonizer(
                      effect: ShimmerEffect(
                        baseColor: Theme.of(context).canvasColor,
                        duration: const Duration(seconds: 3),
                      ),
                      enabled: isLoading,
                      child: const SkeletonCard()),
                Expanded(
                    child: !isLoading
                        ? Column(
                            children: [
                              if (ownTaskLists.isNotEmpty)
                                Text("Deine Listen",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleMedium),
                              getAllListItems(ownTaskLists),
                              if (sharedTaskLists.isNotEmpty)
                                Text("Geteilte Listen",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleMedium),
                              getAllListItems(sharedTaskLists)
                            ],
                          )
                        : Container()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TextField(
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
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
                                createNewItem(CreateTaskListDto(
                                  name: collectionName,
                                ));
                              },
                              child: Text("Neue Liste",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .titleSmall)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
