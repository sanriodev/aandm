import 'dart:convert';

import 'package:aandm/backend/abstract/backend_abstract.dart';
import 'package:aandm/models/api/note_api_model.dart';
import 'package:aandm/models/api/task_api_model.dart';
import 'package:aandm/models/api/task_list_api_model.dart';

class Backend extends ABackend {
  static final Backend _instance = Backend._privateConstructor();
  factory Backend() => _instance;
  Backend._privateConstructor() {
    super.init();
  }

  Future<TaskList> createTaskList(TaskList list) async {
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

  Future<Note> createNote(Note list) async {
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

  Future<List<Note?>> getAllNotes() async {
    final res = await get('note/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final notes = (jsonData['data'] as List<dynamic>)
          .map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList();

      return notes;
    } else {
      throw res;
    }
  }

  Future<Note> getNote(int id) async {
    final res = await get('note/$id');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final note = Note.fromJson(jsonData['data'] as Map<String, dynamic>);

      return note;
    } else {
      throw res;
    }
  }

  Future<Note> updateNote(Note note) async {
    final body = json.encode(note.toJson());
    final res = await put('note/', body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final updatedNote =
          Note.fromJson(jsonData['data'] as Map<String, dynamic>);

      return updatedNote;
    } else {
      throw res;
    }
  }

  Future<Note> deleteNote(int id) async {
    final res = await delete('note/$id');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final note = Note.fromJson(jsonData['data'] as Map<String, dynamic>);

      return note;
    } else {
      throw res;
    }
  }

  Future<Task> createTask(Task task) async {
    final body = json.encode(task.toJson());
    final res = await post('task/', body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final createdTask =
          Task.fromJson(jsonData['data'] as Map<String, dynamic>);

      return createdTask;
    } else {
      throw res;
    }
  }

  Future<List<Task?>> getAllTasks() async {
    final res = await get('task/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final tasks = (jsonData['data'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      return tasks;
    } else {
      throw res;
    }
  }

  Future<Task> updateTask(Task task) async {
    final body = json.encode(task.toJson());
    final res = await put('task/', body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData =
          await json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final updatedTask =
          Task.fromJson(jsonData['data'] as Map<String, dynamic>);

      return updatedTask;
    } else {
      throw res;
    }
  }
}
