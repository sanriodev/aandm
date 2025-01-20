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
    final nextFrDuration = Duration(days: (5 - now.weekday + 7) % 7);

    DateTime nextFriday = now.add(nextFrDuration);
    nextFriday =
        DateTime(nextFriday.year, nextFriday.month, nextFriday.day, 18);
    var durationInseconds = nextFriday.difference(now).inSeconds;
    if (durationInseconds < 0) {
      nextFriday = nextFriday.add(const Duration(days: 7));
      durationInseconds = nextFriday.difference(now).inSeconds;
    }
    return durationInseconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Timer",
              style: Theme.of(context).primaryTextTheme.titleMedium),
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
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "I love you so much. and I miss you every second! \nLuckily we will see each other again in about",
                    style: Theme.of(context).primaryTextTheme.titleSmall!
                      ..copyWith(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                    "${(seconds / 60 / 60 / 24).toStringAsFixed(1)} days",
                    style: Theme.of(context).primaryTextTheme.titleMedium!
                      ..copyWith(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("${(seconds / 60 / 60).toStringAsFixed(1)} hours",
                    style: Theme.of(context).primaryTextTheme.titleMedium!
                      ..copyWith(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("${(seconds / 60).toStringAsFixed(0)} minutes",
                    style: Theme.of(context).primaryTextTheme.titleMedium!
                      ..copyWith(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("${seconds.toStringAsFixed(0)} seconds",
                    style: Theme.of(context).primaryTextTheme.titleMedium!
                      ..copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ));
  }
}
