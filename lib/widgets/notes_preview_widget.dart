import 'package:flutter/material.dart';

class NotesPreviewWidget extends StatefulWidget {
  const NotesPreviewWidget(
      {super.key, required this.themeMode, required this.onPressed});
  final ThemeMode themeMode;
  final VoidCallback onPressed;

  @override
  State<NotesPreviewWidget> createState() => _NotesPreviewWidgetState();
}

class _NotesPreviewWidgetState extends State<NotesPreviewWidget> {
  final List<String> _mockNotes = [
    "Coole Date Ideen...",
    "Netflix need to watch...",
    "Die besten Sachen die ich mit Matteo gekocht habe...",
    "Mimi's Lieblingsspielzeuge 2025...",
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
              children: _mockNotes
                  .take(3) // Show a preview of up to 3 notes
                  .map((note) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.sticky_note_2_outlined,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              note,
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
                'Notes',
                style: Theme.of(context).primaryTextTheme.titleSmall,
              ),
              icon: Icon(
                Icons.note_alt,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          )
        ],
      ),
    );
  }
}
