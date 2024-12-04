import 'package:aandm/models/hive_interface.dart';
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

int getIncrement<T extends HiveModel>(List<T> list) {
  var max = 0;
  if (list.isEmpty) {
    return 1;
  }
  for (var i = 0; i < list.length; i++) {
    if (list[i].id > max) {
      max = list[i].id;
    }
  }
  return max + 1;
}
