import 'package:aandm/models/note.dart';
import 'package:aandm/screens/notes_edit_screen.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> notes = [];
  String collectionName = 'Name der Notiz';

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  void getNotes() {
    final box = Hive.box<Note>('notes');
    final List<Note> notes = box.values.toList();

    setState(() {
      this.notes = notes;
    });
  }

  void createNewItem(Note data) {
    final box = Hive.box<Note>('notes');
    box.add(data);
    setState(() {
      notes.add(data);
    });
  }

  void deleteItem(int index) {
    final box = Hive.box<Note>('notes');
    box.deleteAt(index);
    getNotes();
  }

  ListView getAllListItems() {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          return NoteWidget(
            onTap: () {
              navigateToScreen(
                  context,
                  NotesEditScreen(
                    id: notes[index].id,
                  ),
                  true);
            },
            onDeletePress: () {
              deleteItem(index);
            },
            name: notes[index].name,
            content: notes[index].content,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('listViewNoteVis'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          getNotes();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notizen",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.black,
              tooltip: "I love my gf",
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: getAllListItems()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          style: const TextStyle(color: Colors.grey),
                          controller:
                              TextEditingController(text: collectionName),
                          onChanged: (value) {
                            collectionName = value;
                          },
                          onTap: () {
                            setState(() {
                              collectionName = '';
                            });
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: ElevatedButton(
                          onPressed: () {
                            final newIncrementedId = getIncrement<Note>(notes);
                            createNewItem(Note(
                              newIncrementedId,
                              collectionName,
                              '',
                            ));
                          },
                          child: const Text("Create new List")),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
