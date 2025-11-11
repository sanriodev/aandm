import 'package:flutter/material.dart';

class TodoPreviewWidget extends StatefulWidget {
  const TodoPreviewWidget(
      {super.key, required this.themeMode, required this.onPressed});
  final ThemeMode themeMode;
  final VoidCallback onPressed;

  @override
  State<TodoPreviewWidget> createState() => _TodoPreviewWidgetState();
}

class _TodoPreviewWidgetState extends State<TodoPreviewWidget> {
  final List<String> _mockTodos = [
    "Einkaufen gehen",
    "Matteo von meinem Tag erzählen",
    "Mimi streicheln",
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _mockTodos
                  .take(3) // Show a preview of up to 3 items
                  .map((todo) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.check_box_outline_blank,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              todo,
                              style: TextStyle(
                                color: widget.themeMode == ThemeMode.light
                                    ? Colors.black87
                                    : Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )))
                  .toList(),
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
              ),
              onPressed: widget.onPressed,
              label: Text(
                'Aufgabenisten',
                style: Theme.of(context).primaryTextTheme.titleSmall,
              ),
              icon: Icon(
                Icons.checklist,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          )
        ],
      ),
    );
  }
}
