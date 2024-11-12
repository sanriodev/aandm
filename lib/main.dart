import 'package:aandm/constants/theme.dart';
import 'package:aandm/screens/timer_screen.dart';
import 'package:aandm/screens/to_do_screen.dart';
import 'package:aandm/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      home: const MyHomePage(title: 'A & M'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("A and M"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Fluttertoast.showToast(msg: "I miss you too darling!");
            },
            color: Colors.black,
            tooltip: "I love my gf",
          ),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              navigateToScreen(context, const TimerScreen(), true);
            },
            child: const Text("Timer Screen"),
          ),
          ElevatedButton(
              onPressed: () {
                navigateToScreen(context, const ToDoScreen(), true);
              },
              child: const Text("To-Do List")),
        ],
      )),
    );
  }
}
