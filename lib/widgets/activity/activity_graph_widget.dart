import 'package:aandm/models/activity/activity_model.dart';
import 'package:flutter/material.dart';

class ActivityGraphWidget extends StatelessWidget {
  final List<EventlogMessage<dynamic>> activities;

  const ActivityGraphWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    // Placeholder for actual graph implementation
    return Container(
      height: 200,
      color: Colors.blueAccent,
      child: Center(
        child: Text(
          'Activity Graph with ${activities.length} activities',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
