import 'package:aandm/models/note.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NotesEditScreen extends StatefulWidget {
  const NotesEditScreen({super.key, required this.id});

  @override
  _NotesEditScreenState createState() => _NotesEditScreenState();
  final int id;
}

class _NotesEditScreenState extends State<NotesEditScreen> {
  final TextEditingController _commentController = TextEditingController();
  late Note note;
  @override
  void initState() {
    note = Note(widget.id, 'neue Notiz', 'neue Notiz');
    super.initState();
    _loadNote();
  }

  void _loadNote() {
    final box = Hive.box<Note>('notes');
    final List<Note> notes = box.values.toList();
    note = notes.firstWhere(
      (element) => element.id == widget.id,
      orElse: () {
        return note;
      },
    );
    _commentController.text = note.content;
  }

  Future<void> _saveNote() async {
    await note.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notiz bearbeiten',
            style: Theme.of(context).primaryTextTheme.titleMedium),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              _saveNote();
              Navigator.of(context).pop();
            },
            color: Theme.of(context).primaryIconTheme.color,
            tooltip: "I love my gf",
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.save),
              color: Theme.of(context).primaryIconTheme.color,
              onPressed: () {
                _saveNote();
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[400],
          border: Border.all(width: 0),
        ),
        child: TextField(
            controller: _commentController,
            textAlignVertical: TextAlignVertical.top,
            expands: true,
            maxLines: null,
            onChanged: (value) {
              note.content = value;
            },
            decoration: const InputDecoration(
              hintText: 'Notiz...',
              hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
              contentPadding: EdgeInsets.all(16.0),
              border: InputBorder.none,
            )),
      ),
    );
  }
}
