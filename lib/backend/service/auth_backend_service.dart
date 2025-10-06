// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:aandm/backend/abstract/backend_abstract.dart';
import 'package:aandm/models/base/login_response_model.dart';
import 'package:aandm/util/helpers.dart';
import 'package:hive/hive.dart';

class AuthBackend extends ABackend {
  static final AuthBackend _instance = AuthBackend._privateConstructor();
  LoginResponse? _loggedInUser;
  factory AuthBackend() => _instance;
  AuthBackend._privateConstructor() {
    _checkForLoggedInUser();
    super.init();
  }

  void _checkForLoggedInUser() {
    final box = Hive.box<LoginResponse>('auth');
    final LoginResponse? user = box.get('auth');
    if (user != null &&
        (!jwtIsExpired(user.accessToken) || !jwtIsExpired(user.refreshToken))) {
      loggedInUser = user;
    }
  }

  // ignore: unnecessary_getters_setters
  LoginResponse? get loggedInUser => _loggedInUser;
  set loggedInUser(LoginResponse? user) {
    _loggedInUser = user;
  }

  Future<LoginResponse> postLogin(String username, String password) async {
    final res = await post(
      jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
      'auth/login/',
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data'];
      final loginData =
          LoginResponse.fromJson(jsonData as Map<String, dynamic>);
      loggedInUser = loginData;
      final box = await Hive.openBox<LoginResponse>('auth');
      await box.put('auth', loginData);

      return loginData;
    } else {
      throw res;
    }
  }

  Future<void> postLogout() async {
    final res = await post(
      null,
      'auth/logout',
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      loggedInUser = null;
      return;
    } else {
      throw res;
    }
  }

  Future<LoginResponse?> postRefresh() async {
    final box = Hive.box<LoginResponse>('auth');
    const String url = 'auth/refresh';
    if (_loggedInUser?.accessToken != null) {
      final Map<String, dynamic> loginData = {
        'refresh_token': _loggedInUser?.refreshToken,
      };

      final res = await post(jsonEncode(loginData), url);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final jsonData = await json.decode(utf8.decode(res.bodyBytes));
        if (jsonData != null) {
          final loginData =
              LoginResponse.fromJson(jsonData['data'] as Map<String, dynamic>);
          loggedInUser = loginData;
          await box.put('auth', loginData);
          return loginData;
        }
      } else {
        await box.clear();
        loggedInUser = null;
        throw res;
      }
    }

    return null;
  }
}
