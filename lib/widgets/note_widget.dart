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
    return InkWell(
      onTap: widget.onTap,
      child: Card(
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
                    child: Text(
                      "Name",
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      widget.name,
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      "Inhaltsvorschau",
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "${widget.content.length > 40 ? widget.content.substring(0, 40) : widget.content}...",
                      style: Theme.of(context).primaryTextTheme.bodyMedium!
                        ..copyWith(overflow: TextOverflow.ellipsis),
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
                      onPressed: widget.onDeletePress),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
