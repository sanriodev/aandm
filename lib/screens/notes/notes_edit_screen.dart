import 'package:aandm/backend/service/backend_service.dart';
import 'package:aandm/models/note/note_api_model.dart';
import 'package:aandm/models/note/dto/update_note_dto.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotesEditScreen extends StatefulWidget {
  const NotesEditScreen({super.key, required this.id});

  @override
  _NotesEditScreenState createState() => _NotesEditScreenState();
  final int id;
}

class _NotesEditScreenState extends State<NotesEditScreen> {
  final TextEditingController _commentController = TextEditingController();
  Note? note;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final backend = Backend();
    note = await backend.getNote(widget.id);
    setState(() {
      _commentController.text = note?.content ?? '';
    });
  }

  Future<void> _saveNote() async {
    final backend = Backend();
    final updatedNote = UpdateNoteDto(
      id: note?.id ?? widget.id,
      title: note?.title ?? '',
      privacyMode: note?.privacyMode,
      content: _commentController.text,
    );
    await backend.updateNote(updatedNote);
    await _loadNote();
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
              if (note != null) {
                note!.content = value;
              }
            },
            decoration: InputDecoration(
              hintText: 'Notiz...',
              hintStyle: Theme.of(context).primaryTextTheme.titleSmall,
              contentPadding: const EdgeInsets.all(16.0),
              border: InputBorder.none,
            )),
      ),
    );
  }
}
