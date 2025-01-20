import 'package:flutter/material.dart';

class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key});

  @override
  _SkeletonCardState createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Container(
                width: double.infinity,
                height: 15.0,
                color: Theme.of(context).primaryColor),
            const SizedBox(height: 12.0),
            // Title Placeholder
            Container(
                width: double.infinity,
                height: 30.0,
                color: Theme.of(context).primaryColor),
            const SizedBox(height: 28.0),
            // Description Placeholder
            Container(
                width: double.infinity,
                height: 15.0,
                color: Theme.of(context).primaryColor),
            const SizedBox(height: 4.0),
            Container(
                height: 50.0,
                width: double.infinity,
                color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}
