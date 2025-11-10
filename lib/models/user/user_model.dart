class User {
  int id;
  String username;
  String? email;
  bool publicActivity;

  User({
    required this.id,
    required this.username,
    this.email,
    this.publicActivity = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String?,
      publicActivity: json['publicActivity'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'publicActivity': publicActivity,
    };
  }
}
