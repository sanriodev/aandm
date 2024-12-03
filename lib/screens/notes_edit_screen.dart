import 'package:flutter/material.dart';

class NotesEditScreen extends StatefulWidget {
  const NotesEditScreen({super.key, required this.id});

  @override
  _NotesEditScreenState createState() => _NotesEditScreenState();
  final int id;
}

class _NotesEditScreenState extends State<NotesEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Center(
        child: Text('Edit your note here'),
      ),
    );
  }
}
