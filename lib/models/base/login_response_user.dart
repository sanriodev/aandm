class LoginResponseUser {
  String username;
  String? email;

  LoginResponseUser({
    required this.username,
    this.email,
  });

  factory LoginResponseUser.fromJson(Map<String, dynamic> json) {
    return LoginResponseUser(
      username: json['username'] as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }
}
