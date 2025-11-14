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
      elevation: 2.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.timer,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Timer',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
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
                      width: 120.0,
                      height: 120.0,
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
                      width: 120.0,
                      height: 120.0,
                      showSecondHand: false,
                      textScaleFactor: 1.6,
                      showDigitalClock: false,
                    ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onPressed,
                child: const Text(
                  'Timer anzeigen',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
