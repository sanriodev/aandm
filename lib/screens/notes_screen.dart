import 'package:aandm/models/note.dart';
import 'package:aandm/screens/notes_edit_screen.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:aandm/widgets/note_widget.dart';
import 'package:aandm/widgets/skeleton/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> notes = [];
  String collectionName = 'Name der Notiz';
  bool isLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getNotes();
    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        isLoading = false;
      });
    });
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
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Notizen",
              style: Theme.of(context).primaryTextTheme.titleMedium),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Theme.of(context).primaryIconTheme.color,
              tooltip: "I love my gf",
            ),
          ),
          actions: [
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLoading)
              Skeletonizer(
                  effect: ShimmerEffect(
                    baseColor: Theme.of(context).canvasColor,
                    duration: const Duration(seconds: 3),
                  ),
                  enabled: isLoading,
                  child: const SkeletonCard()),
            Expanded(child: !isLoading ? getAllListItems() : Container()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
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
                        child: Text("Neue Notiz",
                            style:
                                Theme.of(context).primaryTextTheme.titleSmall),
                      ),
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
