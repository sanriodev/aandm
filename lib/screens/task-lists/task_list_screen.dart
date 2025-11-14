// ignore_for_file: use_build_context_synchronously

import 'package:aandm/backend/service/backend_service.dart';
import 'package:aandm/enum/privacy_mode_enum.dart';
import 'package:aandm/models/tasklist/dto/update_task_list_dto.dart';
import 'package:aandm/models/tasklist/task_list_api_model.dart';
import 'package:aandm/models/tasklist/dto/create_task_list_dto.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:aandm/widgets/navigation/bottom_menu.dart';
import 'package:aandm/widgets/skeleton/skeleton_card.dart';
import 'package:aandm/widgets/task_list_widget.dart';
import 'package:blvckleg_dart_core/exception/session_expired.dart';
import 'package:blvckleg_dart_core/service/auth_backend_service.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<TaskList> ownTaskLists = [];
  List<TaskList> sharedTaskLists = [];
  String collectionName = '';
  bool isLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getTaskLists();
  }

  Future<void> getTaskLists() async {
    try {
      setState(() {
        isLoading = true;
      });
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

  Future<void> updatePrivacy(TaskList taskList, PrivacyMode mode) async {
    if (taskList.user?.username != AuthBackend().loggedInUser?.user?.username) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Du kannst die Privatsphäre nur bei deinen eigenen Notizen ändern.')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final backend = Backend();
      await backend.updateTaskList(UpdateTaskListDto(
        id: taskList.id,
        name: taskList.name,
        privacyMode: mode,
      ));
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
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: taskLists.length,
        itemBuilder: (BuildContext context, int index) {
          return TaskListWidget(
              onTap: () {
                navigateToRoute(context, 'tasks',
                    extra: taskLists[index], backEnabled: true);
              },
              onDeletePress: () {
                deleteItem(taskLists[index].id);
              },
              onChangePrivacy: (PrivacyMode mode) {
                updatePrivacy(taskLists[index], mode);
              },
              totalTasks: taskLists[index].tasks.length,
              completedTasks:
                  taskLists[index].tasks.where((test) => test.isDone).length,
              openTasks:
                  taskLists[index].tasks.where((test) => !test.isDone).length,
              taskList: taskLists[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: const BottomMenu(),
      appBar: AppBar(
        title: Text("Aufgabenlisten",
            style: Theme.of(context).primaryTextTheme.titleMedium),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final TextEditingController nameController =
              TextEditingController(text: collectionName);
          await showDialog<void>(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: Text(
                  'Neue Liste',
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      style: Theme.of(context).primaryTextTheme.bodySmall,
                      decoration: InputDecoration(
                        labelText: 'Name der Liste',
                        labelStyle:
                            Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actionsPadding: const EdgeInsets.all(16),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text('Abbrechen',
                        style: Theme.of(context).primaryTextTheme.titleSmall),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Bitte einen Namen eingeben.')),
                        );
                        return;
                      }
                      await createNewItem(CreateTaskListDto(name: name));
                      if (mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    child: Text('Erstellen',
                        style: Theme.of(context).primaryTextTheme.titleSmall),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Neue Liste',
        child: const Icon(Icons.add),
      ),
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
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ownTaskLists.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                "Deine Listen",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ),
                            ),
                          getAllListItems(ownTaskLists),
                          if (sharedTaskLists.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                "Geteilte Listen",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ),
                            ),
                          getAllListItems(sharedTaskLists)
                        ],
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
