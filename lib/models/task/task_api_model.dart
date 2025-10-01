import 'package:aandm/models/tasklist/task_list_api_model.dart';

class Task {
  int id;
  String title;
  String? content;
  bool isDone;
  TaskList? taskList;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
    this.taskList,
    this.content,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      isDone: json['isDone'] as bool,
      taskList: json['taskList'] != null
          ? TaskList.fromJson(json['taskList'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isDone': isDone,
      'taskList': taskList?.toJson(),
    };
  }
}
