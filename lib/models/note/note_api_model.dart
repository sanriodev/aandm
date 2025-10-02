import 'package:aandm/models/base/base_user_relation.dart';
import 'package:aandm/models/user/user_model.dart';
import 'package:aandm/enum/privacy_mode_enum.dart';

class Note extends BaseUserRelation {
  int id;
  String title;
  String? content;
  PrivacyMode privacyMode;

  Note({
    required this.id,
    required this.title,
    required this.privacyMode,
    this.content,
    super.user,
    super.lastModifiedUser,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      privacyMode: PrivacyMode.fromJson(json['privacyMode']),
      user: (json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null),
      lastModifiedUser: (json['lastModifiedUser'] != null
          ? User.fromJson(json['lastModifiedUser'] as Map<String, dynamic>)
          : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'privacyMode': privacyMode,
      'user': user?.toJson(),
      'lastModifiedUser': lastModifiedUser?.toJson(),
    };
  }
}
