import 'package:aandm/models/base/login_response_user.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class LoginResponse extends HiveObject {
  @HiveField(0)
  final String accessToken;
  @HiveField(1)
  final String refreshToken;
  final LoginResponseUser? user;

  LoginResponse(
      {required this.accessToken, required this.refreshToken, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: LoginResponseUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
