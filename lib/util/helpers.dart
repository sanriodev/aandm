import 'package:flutter/material.dart';

void navigateToScreen(BuildContext context, Widget screen, bool backEnabled) {
  Future.delayed(Duration.zero, () async {
    if (backEnabled) {
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return screen;
      }));
    } else {
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => false,
      );
    }
  });
}
