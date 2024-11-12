import 'package:flutter/material.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  int seconds = 0;
  int buttonPressCounter = 0;
  @override
  void initState() {
    super.initState();
  }

  createNewItem() {}
  deleteItem(int index) {}

  ListView getAllListItems() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text("Item $index"),
            subtitle: const Text("This is a subtitle"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteItem(index);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.black,
            tooltip: "I love my gf",
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: getAllListItems()),
          Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () {
                    createNewItem();
                  },
                  child: const Text("Create new Item"))),
        ],
      ),
    );
  }
}
