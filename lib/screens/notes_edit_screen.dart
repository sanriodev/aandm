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
        title: Text('Notiz bearbeiten'),
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
      body: Center(
        child: Text('Edit your note here'),
      ),
    );
  }
}
