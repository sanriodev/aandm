import 'package:aandm/models/user/user_model.dart';
import 'package:aandm/enum/privacy_mode_enum.dart';
import 'package:aandm/widgets/accordion/accordion_section.dart';
import 'package:aandm/widgets/accordion/task_list_accordion.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskListWidget extends StatefulWidget {
  final String taskListName;
  final int totalTaks;
  final int completedTasks;
  final int openTasks;
  final void Function()? onTap;
  final void Function()? onDeletePress;
  final PrivacyMode? privacyMode;
  final void Function(PrivacyMode mode)? onChangePrivacy;
  final User? author;
  final User? lastModifiedUser;

  const TaskListWidget(
      {super.key,
      required this.taskListName,
      required this.totalTaks,
      required this.completedTasks,
      required this.openTasks,
      this.onDeletePress,
      this.onTap,
      this.privacyMode,
      this.onChangePrivacy,
      this.author,
      this.lastModifiedUser});

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
              key: UniqueKey(),
              endActionPane: ActionPane(
                motion: BehindMotion(),
                extentRatio: 0.3,
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(5),
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
                          // Padding(
                          //   padding: const EdgeInsets.all(12),
                          //   child: PopupMenuButton<PrivacyMode>(
                          //     tooltip: 'Privatsphäre',
                          //     onSelected: (mode) =>
                          //         widget.onChangePrivacy?.call(mode),
                          //     itemBuilder: (context) => [
                          //       const PopupMenuItem(
                          //         value: PrivacyMode.private,
                          //         child: Text('Privat'),
                          //       ),
                          //       const PopupMenuItem(
                          //         value: PrivacyMode.protected,
                          //         child: Text('Geschützt'),
                          //       ),
                          //       const PopupMenuItem(
                          //         value: PrivacyMode.public,
                          //         child: Text('Öffentlich'),
                          //       ),
                          //     ],
                          //     child: Icon(
                          //       privacyIconFor(widget.privacyMode),
                          //       color: Theme.of(context).primaryIconTheme.color,
                          //     ),
                          //   ),
                          // ),
                          Text(widget.taskListName,
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
                                Text("Einträge gesamt: ${widget.totalTaks}",
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
                                  percentage:
                                      (widget.completedTasks / widget.totalTaks)
                                              .isNaN
                                          ? 0
                                          : (widget.completedTasks /
                                              widget.totalTaks),
                                  lineHeight: 20,
                                  backgroundColor: Colors.black26,
                                  progressBarColor: Colors.purple.shade400,
                                  child: Text(
                                      "${(((widget.completedTasks / widget.totalTaks).isNaN ? 0 : (widget.completedTasks / widget.totalTaks)) * 100).toStringAsFixed(2)}%",
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
                                widget.author != null
                                    ? widget.author!.username
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
                                widget.lastModifiedUser != null
                                    ? widget.lastModifiedUser!.username
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
