class LoginResponseUser {
  String username;
  String? email;
  bool? publicActivity;

  LoginResponseUser({
    required this.username,
    this.publicActivity = false,
    this.email,
  });

  factory LoginResponseUser.fromJson(Map<String, dynamic> json) {
    return LoginResponseUser(
      username: json['username'] as String,
      email: json['email'] as String?,
      publicActivity: json['publicActivity'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'publicActivity': publicActivity,
    };
  }
}
