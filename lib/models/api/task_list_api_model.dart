import 'package:aandm/models/api/base_user_relation.dart';
import 'package:aandm/models/api/task_api_model.dart';
import 'package:aandm/models/auth/user_model.dart';
import 'package:aandm/models/enum/privacy_mode_enum.dart';

class TaskList extends BaseUserRelation {
  int id;
  String name;
  PrivacyMode privacyMode;
  List<Task> tasks;

  TaskList({
    required this.id,
    required this.name,
    required this.privacyMode,
    required this.tasks,
    required super.user,
    required super.lastModifiedUser,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) {
    return TaskList(
        id: json['id'] as int,
        name: json['name'] as String,
        privacyMode: json['privacyMode'] as PrivacyMode,
        tasks: (json['tasks'] as List<dynamic>)
            .map((e) => Task.fromJson(e as Map<String, dynamic>))
            .toList(),
        user: User.fromJson(json['user'] as Map<String, dynamic>),
        lastModifiedUser:
            User.fromJson(json['lastModifiedUser'] as Map<String, dynamic>));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'privacyMode': privacyMode,
      'tasks': tasks.map((e) => e.toJson()).toList(),
      'user': user.toJson(),
      'lastModifiedUser': lastModifiedUser.toJson(),
    };
  }
}
