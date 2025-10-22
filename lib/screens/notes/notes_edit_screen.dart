// ignore_for_file: use_build_context_synchronously

import 'package:aandm/backend/service/auth_backend_service.dart';
import 'package:aandm/backend/service/backend_service.dart';
import 'package:aandm/enum/privacy_mode_enum.dart';
import 'package:aandm/models/exception/session_expired.dart';
import 'package:aandm/models/note/note_api_model.dart';
import 'package:aandm/models/note/dto/update_note_dto.dart';
import 'package:aandm/util/helpers.dart';
import 'package:aandm/widgets/app_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotesEditScreen extends StatefulWidget {
  const NotesEditScreen({super.key});

  @override
  _NotesEditScreenState createState() => _NotesEditScreenState();
}

class _NotesEditScreenState extends State<NotesEditScreen> {
  final TextEditingController _commentController = TextEditingController();
  late int id;
  Note? note;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    id = GoRouterState.of(context).extra! as int;
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    try {
      final backend = Backend();
      note = await backend.getNote(id);
      setState(() {
        _commentController.text = note?.content ?? '';
      });
    } catch (e) {
      if (e is SessionExpiredException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte melde dich erneut an.')),
        );

        await deleteBoxAndNavigateToLogin(context);
      }
    }
  }

  Future<void> _saveNote() async {
    try {
      final backend = Backend();
      final updatedNote = UpdateNoteDto(
        id: note?.id ?? id,
        title: note?.title ?? '',
        privacyMode: note?.privacyMode,
        content: _commentController.text,
      );
      await backend.updateNote(updatedNote);
      await _loadNote();
    } catch (e) {
      if (e is SessionExpiredException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte melde dich erneut an.')),
        );

        await deleteBoxAndNavigateToLogin(context);
      }
    }
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
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.zero,
          boxShadow: const [],
          border: Border.all(
            color: Colors.transparent,
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        child: TextField(
          controller: _commentController,
          enabled: note != null &&
              (note!.user?.username ==
                      AuthBackend().loggedInUser?.user?.username ||
                  note!.privacyMode == PrivacyMode.public),
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
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            filled: false,
          ),
        ),
      ),
    );
  }
}
