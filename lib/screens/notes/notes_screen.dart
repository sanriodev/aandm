// ignore_for_file: use_build_context_synchronously

import 'package:aandm/backend/service/auth_backend_service.dart';
import 'package:aandm/backend/service/backend_service.dart';
import 'package:aandm/models/exception/session_expired.dart';
import 'package:aandm/models/note/note_api_model.dart';
import 'package:aandm/models/note/dto/create_note_dto.dart';
import 'package:aandm/screens/notes/notes_edit_screen.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:aandm/widgets/note_widget.dart';
import 'package:aandm/widgets/skeleton/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> ownNotes = [];
  List<Note> sharedNotes = [];
  String collectionName = 'Name der Notiz';
  bool isLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  Future<void> getNotes() async {
    try {
      final backend = Backend();
      final res = await backend.getAllNotes();
      final own = res
          .where((element) =>
              element.user!.username ==
              AuthBackend().loggedInUser?.user?.username)
          .toList();
      final shared = res
          .where((element) =>
              element.user!.username !=
              AuthBackend().loggedInUser?.user?.username)
          .toList();
      setState(() {
        isLoading = false;
        ownNotes = own;
        sharedNotes = shared;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is SessionExpiredException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte melde dich erneut an.')),
        );

        await deleteBoxAndNavigateToLogin(context);
      }
    }
  }

  Future<void> createNewItem(CreateNoteDto data) async {
    setState(() {
      isLoading = true;
    });
    try {
      final backend = Backend();
      await backend.createNote(data);
      await getNotes();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is SessionExpiredException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte melde dich erneut an.')),
        );

        await deleteBoxAndNavigateToLogin(context);
      }
    }
  }

  Future<void> deleteItem(int id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final backend = Backend();
      await backend.deleteNote(id);
      await getNotes();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is SessionExpiredException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte melde dich erneut an.')),
        );

        await deleteBoxAndNavigateToLogin(context);
      }
    }
  }

  ListView getAllListItems(List<Note> notes) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
              deleteItem(
                notes[index].id,
              );
            },
            name: notes[index].title,
            content: notes[index].content ?? '',
            author: notes[index].user,
            lastModifiedUser: notes[index].lastModifiedUser,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('listViewNoteVis'),
      onVisibilityChanged: (info) async {
        if (info.visibleFraction > 0) {
          await getNotes();
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
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          onRefresh: () async {
            setState(() {
              isLoading = true;
            });
            return await getNotes();
          },
          child: Column(
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
              Expanded(
                  child: !isLoading
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (ownNotes.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Text(
                                    "Deine Notizen",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleMedium,
                                  ),
                                ),
                              getAllListItems(ownNotes),
                              if (sharedNotes.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Text(
                                    "Geteilte Notizen",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleMedium,
                                  ),
                                ),
                              getAllListItems(sharedNotes)
                            ],
                          ),
                        )
                      : Container()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TextField(
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
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
                            createNewItem(CreateNoteDto(
                              title: collectionName,
                              content: '',
                            ));
                          },
                          child: Text("Neue Notiz",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleSmall),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
