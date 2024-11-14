import 'package:aandm/widgets/accordion/accordion_section.dart';
import 'package:aandm/widgets/accordion/task_list_accordion.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:getwidget/types/gf_progress_type.dart';

class TaskListWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TaskListAccordion(
      children: [
        TaskListAccordionSection(
            headerBackgroundColor: Colors.purple.shade400,
            isOpen: true,
            leftHeaderIcon: const Icon(
              Icons.circle,
              color: Colors.green,
              size: 20,
            ),
            header: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: IconButton(
                      icon: const Icon(Icons.delete), onPressed: onDeletePress),
                ),
                Text(
                  taskListName,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            content: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Einträge gesamt: $totalTaks"),
                      Text("Einträge abgeschlossen: $completedTasks"),
                      Text("Einträge offen: $openTasks"),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 100,
                        child: Align(
                          child: GFProgressBar(
                            width: 100,
                            radius: 100,
                            percentage: 0.80,
                            lineHeight: 100,
                            circleWidth: 10,
                            type: GFProgressType.circular,
                            backgroundColor: Colors.black26,
                            progressBarColor: Colors.purple.shade400,
                            child: const Text("80%"),
                          ),
                        ),
                      ),
                      const Text("Abgeschlossen"),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
