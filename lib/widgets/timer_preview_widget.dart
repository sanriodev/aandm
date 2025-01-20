import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

class TimerPreviewWidget extends StatefulWidget {
  const TimerPreviewWidget(
      {super.key, required this.themeMode, required this.onPressed});
  final ThemeMode themeMode;
  final VoidCallback onPressed;

  @override
  State<TimerPreviewWidget> createState() => _TimerPreviewWidgetState();
}

class _TimerPreviewWidgetState extends State<TimerPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: widget.themeMode == ThemeMode.light
                  ? AnalogClock(
                      showAllNumbers: true,
                      tickColor: Colors.black,
                      hourHandColor: Colors.red,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4.0,
                          ),
                          color: Colors.grey,
                          shape: BoxShape.circle),
                      width: 100.0,
                      height: 100.0,
                      showSecondHand: false,
                      numberColor: Colors.black87,
                      textScaleFactor: 1.6,
                      showDigitalClock: false,
                    )
                  : AnalogClock.dark(
                      hourHandColor: Colors.red,
                      showAllNumbers: true,
                      tickColor: Colors.white,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4.0, color: Colors.white),
                          color: Colors.grey,
                          shape: BoxShape.circle),
                      width: 100.0,
                      height: 100.0,
                      showSecondHand: false,
                      textScaleFactor: 1.6,
                      showDigitalClock: false,
                    ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
              ),
              onPressed: widget.onPressed,
              label: Text(
                'Timer ',
                style: Theme.of(context).primaryTextTheme.titleSmall,
              ),
              icon: Icon(
                Icons.timer,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          )
        ],
      ),
    );
  }
}
