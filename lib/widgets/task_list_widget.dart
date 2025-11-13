import 'package:aandm/enum/privacy_mode_enum.dart';
import 'package:aandm/models/tasklist/task_list_api_model.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/accordion/accordion_section.dart';
import 'package:aandm/widgets/accordion/task_list_accordion.dart';
import 'package:blvckleg_dart_core/service/auth_backend_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskListWidget extends StatefulWidget {
  final int totalTasks;
  final int completedTasks;
  final int openTasks;
  final TaskList taskList;
  final void Function()? onTap;
  final void Function()? onDeletePress;
  final void Function(PrivacyMode mode)? onChangePrivacy;

  const TaskListWidget({
    super.key,
    required this.taskList,
    required this.totalTasks,
    required this.completedTasks,
    required this.openTasks,
    this.onDeletePress,
    this.onTap,
    this.onChangePrivacy,
  });

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned.fill(
            child: Builder(
                builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        color: Colors.red,
                      ),
                    )),
          ),
          Slidable(
              enabled: widget.taskList.user?.username ==
                  AuthBackend().loggedInUser?.user?.username,
              key: UniqueKey(),
              endActionPane: ActionPane(
                motion: BehindMotion(),
                extentRatio: 0.3,
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(12),
                    onPressed: (_) => widget.onDeletePress?.call(),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                  ),
                ],
              ),
              child: TaskListAccordion(
                children: [
                  TaskListAccordionSection(
                    headerBackgroundColor: Colors.purple.shade400,
                    isOpen: false,
                    header: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Privacy mode button in place of the old delete button
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: PopupMenuButton<PrivacyMode>(
                              enabled: widget.taskList.user?.username ==
                                  AuthBackend().loggedInUser?.user?.username,
                              tooltip: 'Privatsphäre',
                              onSelected: (mode) =>
                                  widget.onChangePrivacy?.call(mode),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: PrivacyMode.private,
                                  child: Text(
                                      'Privat - nur du kannst sehen/bearbeiten'),
                                ),
                                const PopupMenuItem(
                                  value: PrivacyMode.protected,
                                  child: Text(
                                      'Geschützt - alle können sehen, bearbeiten nur du'),
                                ),
                                const PopupMenuItem(
                                  value: PrivacyMode.public,
                                  child: Text(
                                      'Öffentlich - alle können sehen/bearbeiten'),
                                ),
                              ],
                              child: Icon(
                                privacyIconFor(widget.taskList.privacyMode),
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                          ),
                          Text(widget.taskList.name,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium),
                        ],
                      ),
                    ),
                    content: InkWell(
                      onTap: widget.onTap,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Colors.purple,
                                  size: 15,
                                ),
                                Text("Einträge gesamt: ${widget.totalTasks}",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 15,
                                ),
                                Text(
                                    "Einträge abgeschlossen: ${widget.completedTasks}",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                Text("Einträge offen: ${widget.openTasks}",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child: Text(
                                    "Aktueller Fortschritt",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium,
                                  ),
                                ),
                                GFProgressBar(
                                  percentage: (widget.completedTasks /
                                              widget.totalTasks)
                                          .isNaN
                                      ? 0
                                      : (widget.completedTasks /
                                          widget.totalTasks),
                                  lineHeight: 20,
                                  backgroundColor: Colors.black26,
                                  progressBarColor: Colors.purple.shade400,
                                  child: Text(
                                      "${(((widget.completedTasks / widget.totalTasks).isNaN ? 0 : (widget.completedTasks / widget.totalTasks)) * 100).toStringAsFixed(2)}%",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: PhosphorIcon(
                                  PhosphorIconsRegular.user,
                                  size: 16,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                              Text(
                                widget.taskList.user != null
                                    ? widget.taskList.user!.username
                                    : "unknown",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: PhosphorIcon(
                                  PhosphorIconsRegular.pencil,
                                  size: 16,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                              Text(
                                widget.taskList.lastModifiedUser != null
                                    ? widget.taskList.lastModifiedUser!.username
                                    : "unknown",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
