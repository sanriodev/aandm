import 'dart:convert';

import 'package:aandm/models/hive_interface.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void navigateToScreen(BuildContext context, Widget screen, bool backEnabled) {
  Future.delayed(Duration.zero, () async {
    if (backEnabled) {
      // ignore: use_build_context_synchronously
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return screen;
      }));
    } else {
      await Navigator.pushAndRemoveUntil(
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

dynamic decodeJwt(String jwtString) {
  final parts = jwtString.split('.');

  //final encodedPayload = addPadding(parts[1]);
  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
    case 3:
      output += '=';
    default:
      throw Exception('Illegal base64url string!');
  }

  return utf8.decode(base64Url.decode(output));
}

bool jwtIsExpired(String rawJwtString) {
  final Map<String, dynamic> json =
      decodeJwt(rawJwtString) as Map<String, dynamic>;
  return DateTime.now().millisecondsSinceEpoch > (json['exp'] as int) * 1000;
}

Future<void> launchUrlInBrowser(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
