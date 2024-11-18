import 'package:aandm/widgets/accordion/accordion_section.dart';
import 'package:aandm/widgets/accordion/task_list_accordion.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';

class TaskListWidget extends StatefulWidget {
  final String taskListName;
  final int totalTaks;
  final int completedTasks;
  final int openTasks;
  final void Function()? onTap;
  final void Function()? onDeletePress;

  const TaskListWidget(
      {super.key,
      required this.taskListName,
      required this.totalTaks,
      required this.completedTasks,
      required this.openTasks,
      this.onDeletePress,
      this.onTap});

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  @override
  Widget build(BuildContext context) {
    return TaskListAccordion(
      children: [
        TaskListAccordionSection(
            headerBackgroundColor: Colors.purple.shade400,
            isOpen: false,
            header: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: widget.onDeletePress),
                ),
                Text(
                  widget.taskListName,
                ),
              ],
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
                        Text("Einträge gesamt: ${widget.totalTaks}"),
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
                            "Einträge abgeschlossen: ${widget.completedTasks}"),
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
                        Text("Einträge offen: ${widget.openTasks}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          child: Text(
                            "Aktueller Fortschritt",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        GFProgressBar(
                          percentage:
                              (widget.completedTasks / widget.totalTaks).isNaN
                                  ? 0
                                  : (widget.completedTasks / widget.totalTaks),
                          lineHeight: 20,
                          backgroundColor: Colors.black26,
                          progressBarColor: Colors.purple.shade400,
                          child: Text(
                              "${(((widget.completedTasks / widget.totalTaks).isNaN ? 0 : (widget.completedTasks / widget.totalTaks)) * 100).toStringAsFixed(2)}%"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
