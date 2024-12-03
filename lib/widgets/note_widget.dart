import 'package:aandm/widgets/accordion/accordion_section.dart';
import 'package:aandm/widgets/accordion/task_list_accordion.dart';
import 'package:flutter/material.dart';

class NoteWidget extends StatefulWidget {
  final String name;
  final String content;
  final void Function()? onTap;
  final void Function()? onDeletePress;

  const NoteWidget(
      {super.key,
      required this.name,
      required this.content,
      this.onDeletePress,
      this.onTap});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
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
                  widget.name,
                ),
              ],
            ),
            content: InkWell(
              onTap: widget.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.content,
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
