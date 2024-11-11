import 'dart:async';

import 'package:aandm/constants/theme.dart';
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
  int seconds = 0;
  int buttonPressCounter = 0;
  @override
  void initState() {
    super.initState();
    seconds = getSecondsUntilNextFriday();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });
    });
  }

  int getSecondsUntilNextFriday() {
    DateTime now = DateTime.now();
    DateTime nextFriday = now.add(Duration(days: (5 - now.weekday + 7) % 7));
    nextFriday =
        DateTime(nextFriday.year, nextFriday.month, nextFriday.day, 18, 0, 0);
    return nextFriday.difference(now).inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "I love you so much. and I miss you every second! \nLuckily we will see each other again in about",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                    "${(seconds / 60 / 60 / 24).toStringAsFixed(1)} days",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("${(seconds / 60 / 60).toStringAsFixed(1)} hours",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("${(seconds / 60).toStringAsFixed(0)} minutes",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("${seconds.toStringAsFixed(0)} seconds",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22)),
              ),
            ],
          ),
        ));
  }
}
