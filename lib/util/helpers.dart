import 'dart:convert';

import 'package:aandm/backend/service/auth_backend_service.dart';
import 'package:aandm/enum/privacy_mode_enum.dart';
import 'package:aandm/models/base/login_response_model.dart';
import 'package:aandm/models/hive_interface.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void navigateToRoute(
  BuildContext context,
  String routeName, {
  Object? extra,
  bool backEnabled = false,
}) {
  if (context.mounted) {
    if (backEnabled) {
      context.pushNamed(routeName, extra: extra);
    } else {
      context.goNamed(routeName, extra: extra);
    }
  }
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

Future<void> deleteBoxAndNavigateToLogin(BuildContext context) async {
  final Box<LoginResponse> loginBox = Hive.box<LoginResponse>('auth');

  await loginBox.delete('auth');

  final AuthBackend authBackend = AuthBackend();
  authBackend.loggedInUser = null;

  if (context.mounted) {
    navigateToRoute(
      context,
      'login',
    );
  }
}

IconData privacyIconFor(PrivacyMode? mode) {
  switch (mode) {
    case PrivacyMode.protected:
      return PhosphorIconsRegular.shield;
    case PrivacyMode.public:
      return PhosphorIconsRegular.eye;
    case PrivacyMode.private:
    default:
      return PhosphorIconsRegular.lock;
  }
}
