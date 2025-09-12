import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class LoginResponse extends HiveObject {
  @HiveField(0)
  final String access;
  @HiveField(1)
  final String refresh;

  LoginResponse({required this.access, required this.refresh});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
    );
  }
}
