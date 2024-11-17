import 'dart:async';

import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
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
    final DateTime now = DateTime.now();
    final nextFrDuration = Duration(
        days: ((5 - now.weekday + 7) % 7 > 0 ? (5 - now.weekday + 7) % 7 : 7));
    DateTime nextFriday = now.add(nextFrDuration);
    nextFriday =
        DateTime(nextFriday.year, nextFriday.month, nextFriday.day, 18);
    return nextFriday.difference(now).inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Timer",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
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
