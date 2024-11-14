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
            isOpen: false,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.purple,
                              size: 15,
                            ),
                            Text("Einträge gesamt: $totalTaks"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: 15,
                            ),
                            Text("Einträge abgeschlossen: $completedTasks"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.red,
                              size: 15,
                            ),
                            Text("Einträge offen: $openTasks"),
                          ],
                        ),
                      ),
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
                            percentage: (completedTasks / totalTaks).isNaN
                                ? 0
                                : (completedTasks / totalTaks),
                            lineHeight: 100,
                            circleWidth: 10,
                            type: GFProgressType.circular,
                            backgroundColor: Colors.black26,
                            progressBarColor: Colors.purple.shade400,
                            child: Text(
                                "${((completedTasks / totalTaks).isNaN ? 0 : (completedTasks / totalTaks)) * 100}%"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
