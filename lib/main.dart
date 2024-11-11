import 'package:aandm/constants/theme.dart';
import 'package:aandm/models/countdown_values.dart';
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
  final CountDownValues countDownValues = CountDownValues.getValues();
  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  @override
  void initState() {
    countDownValues.getCountDownStream().listen((timeData) => setState(() {
          days = timeData.days;
          hours = timeData.hours;
          minutes = timeData.minutes;
          seconds = timeData.seconds;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          leading: ElevatedButton(onPressed: () {
            Fluttertoast.showToast(msg: "I love my girl so much");
          },
          child: const Text("press me")),
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
                child: Text('$days days.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$hours hours.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$minutes minutes.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$seconds seconds.'),
              ),
              const Padding(padding: EdgeInsets.all(8.0), child: Text("I love my girlfriend so much omg!!!", style: TextStyle(fontWeight: FontWeight.bold,)),)
            ],
          ),
        ));
  }
}
