// ignore_for_file: use_build_context_synchronously

import 'package:aandm/backend/service/auth_backend_service.dart';
import 'package:aandm/backend/service/backend_service.dart';
import 'package:aandm/enum/privacy_mode_enum.dart';
import 'package:aandm/models/exception/session_expired.dart';
import 'package:aandm/models/note/dto/update_note_dto.dart';
import 'package:aandm/models/note/note_api_model.dart';
import 'package:aandm/models/note/dto/create_note_dto.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:aandm/widgets/navigation/bottom_menu.dart';
import 'package:aandm/widgets/note_widget.dart';
import 'package:aandm/widgets/skeleton/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> ownNotes = [];
  List<Note> sharedNotes = [];
  bool isLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  Future<void> getNotes() async {
    try {
      setState(() {
        isLoading = true;
      });
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

  Future<void> updatePrivacy(Note note, PrivacyMode mode) async {
    if (note.user?.username != AuthBackend().loggedInUser?.user?.username) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Du kannst die Privatsphäre nur bei deinen eigenen Notizen ändern.')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final backend = Backend();
      await backend.updateNote(UpdateNoteDto(
        id: note.id,
        title: note.title,
        privacyMode: mode,
      ));
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
              navigateToRoute(context, 'notes-edit',
                  extra: notes[index].id, backEnabled: true);
            },
            onDeletePress: () {
              deleteItem(
                notes[index].id,
              );
            },
            onChangePrivacy: (PrivacyMode mode) {
              updatePrivacy(notes[index], mode);
            },
            note: notes[index],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: const BottomMenu(),
      appBar: AppBar(
        title: Text("Notizen",
            style: Theme.of(context).primaryTextTheme.titleMedium),
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: IconButton(
        //     icon: const Icon(Icons.arrow_back_rounded),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //     color: Theme.of(context).primaryIconTheme.color,
        //     tooltip: "I love my gf",
        //   ),
        // ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nameController = TextEditingController();
          await showDialog<void>(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: Text(
                  'Neue Notiz',
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      style: Theme.of(context).primaryTextTheme.bodySmall,
                      decoration: InputDecoration(
                        labelText: 'Name der Notiz',
                        labelStyle:
                            Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actionsPadding: const EdgeInsets.all(16),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text('Abbrechen',
                        style: Theme.of(context).primaryTextTheme.titleSmall),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bitte einen Namen eingeben.'),
                          ),
                        );
                        return;
                      }
                      await createNewItem(CreateNoteDto(
                        title: name,
                        content: '',
                      ));
                      if (mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    child: Text('Erstellen',
                        style: Theme.of(context).primaryTextTheme.titleSmall),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Neue Notiz',
        child: const Icon(Icons.add),
      ),
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
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
