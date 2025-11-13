import 'package:aandm/models/base/base_user_relation.dart';
import 'package:aandm/models/task/task_api_model.dart';
import 'package:aandm/enum/privacy_mode_enum.dart';
import 'package:blvckleg_dart_core/models/user/user_model.dart';

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
    super.user,
    super.lastModifiedUser,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) {
    return TaskList(
      id: json['id'] as int,
      name: json['name'] as String,
      privacyMode: PrivacyMode.fromJson(json['privacyMode']),
      tasks: json['tasks'] != null
          ? (json['tasks'] as List<dynamic>)
              .map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
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
      'name': name,
      'privacyMode': privacyMode,
      'tasks': tasks.map((e) => e.toJson()).toList(),
      'user': user?.toJson(),
      'lastModifiedUser': lastModifiedUser?.toJson(),
    };
  }
}
