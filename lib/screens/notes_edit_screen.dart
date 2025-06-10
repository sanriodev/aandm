import 'package:aandm/models/note.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotesEditScreen extends StatefulWidget {
  const NotesEditScreen({super.key, required this.id});

  @override
  _NotesEditScreenState createState() => _NotesEditScreenState();
  final int id;
}

class _NotesEditScreenState extends State<NotesEditScreen> {
  final TextEditingController _commentController = TextEditingController();
  late Note note;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
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
          IconButton(
            color: Theme.of(context).primaryIconTheme.color,
            icon: const PhosphorIcon(
              PhosphorIconsRegular.gear,
              semanticLabel: 'Einstellungen',
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: AppDrawer(),
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
            style: Theme.of(context).primaryTextTheme.titleSmall,
            onChanged: (value) {
              note.content = value;
            },
            
            decoration: const InputDecoration(
              hintText: 'Notiz...',
              hintStyle: Theme.of(context).primaryTextTheme.titleSmall,
              contentPadding: EdgeInsets.all(16.0),
              border: InputBorder.none,
            )),
      ),
    );
  }
}
