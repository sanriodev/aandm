import 'package:aandm/constants/theme.dart';
import 'package:flutter/material.dart';

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
  }

  incrementCounter() {
    setState(() {
      buttonPressCounter++;
    });
  }

  int getSecondsUntilNextFriday() {
    //this should get the number of seconds from now until the next friday at 6pm
    int secondsDiff = 0;
    DateTime now = DateTime.now();
    if (now.weekday <= 5) {
      var dayDiff = 5 - now.weekday;
      secondsDiff = DateTime(now.year, now.month, now.weekday + dayDiff, 18, 00)
          .difference(now)
          .inSeconds;
    } else if (now.weekday == 5) {
      secondsDiff = DateTime(now.year, now.month, now.weekday, 18, 00)
          .difference(now)
          .inSeconds;
    } else if (now.weekday > 5) {
      var dayDiff = (now.weekday + 5) % 7;
      secondsDiff = DateTime(now.year, now.month, now.day + dayDiff, 18, 00)
          .difference(now)
          .inSeconds;
    }
    return secondsDiff;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          leading: ElevatedButton(
              onPressed: () {
                incrementCounter();
              },
              child: const Icon(Icons.heart_broken_outlined)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('I miss you so much. I can\'t wait to see you.'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('We will see each other again in about:'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${seconds / 60 / 60 / 24} days.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${seconds / 60 / 60} hours.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${seconds / 60} minutes.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$seconds seconds.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("I love my girlfriend $buttonPressCounter times",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              )
            ],
          ),
        ));
  }
}
