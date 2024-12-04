import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

class TimerPreviewWidget extends StatefulWidget {
  const TimerPreviewWidget({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<TimerPreviewWidget> createState() => _TimerPreviewWidgetState();
}

class _TimerPreviewWidgetState extends State<TimerPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
              child: AnalogClock(
                showAllNumbers: true,
                tickColor: Colors.black,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                    ),
                    color: Colors.transparent,
                    shape: BoxShape.circle),
                width: 100.0,
                height: 100.0,
                showSecondHand: false,
                numberColor: Colors.black87,
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
              label: Text('Timer '),
              icon: Icon(Icons.timer),
            ),
          )
        ],
      ),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }
}
