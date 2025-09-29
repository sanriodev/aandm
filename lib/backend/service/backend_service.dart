import 'dart:convert';

import 'package:aandm/backend/abstract/backend_abstract.dart';
import 'package:aandm/models/api/note_api_model.dart';
import 'package:aandm/models/api/task_list_api_model.dart';

class Backend extends ABackend {
  static final Backend _instance = Backend._privateConstructor();
  factory Backend() => _instance;
  Backend._privateConstructor() {
    super.init();
  }

  Future<TaskList?> createTaskList(TaskList list) async {
    final body = json.encode(list.toJson());
    final res = await post('task-list/', body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final taskList =
          TaskList.fromJson(jsonData['data'] as Map<String, dynamic>);

      return taskList;
    } else {
      throw res;
    }
  }

  Future<List<TaskList?>> getAllTaskLists() async {
    final res = await get('task-list/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final taskLists = (jsonData['data'] as List<dynamic>)
          .map((e) => TaskList.fromJson(e as Map<String, dynamic>))
          .toList();

      return taskLists;
    } else {
      throw res;
    }
  }

  Future<TaskList> deleteTaskList(int id) async {
    final res = await delete('task-list/$id');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final taskList =
          TaskList.fromJson(jsonData['data'] as Map<String, dynamic>);

      return taskList;
    } else {
      throw res;
    }
  }

  Future<Note?> createNote(Note list) async {
    final body = json.encode(list.toJson());
    final res = await post('task-list/', body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final note = Note.fromJson(jsonData['data'] as Map<String, dynamic>);

      return note;
    } else {
      throw res;
    }
  }
}
