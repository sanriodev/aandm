// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:aandm/backend/abstract/backend_abstract.dart';
import 'package:aandm/models/note/note_api_model.dart';
import 'package:aandm/models/task/dto/create_task_dto.dart';
import 'package:aandm/models/task/task_api_model.dart';
import 'package:aandm/models/tasklist/dto/update_task_list_dto.dart';
import 'package:aandm/models/tasklist/task_list_api_model.dart';
import 'package:aandm/models/note/dto/create_note_dto.dart';
import 'package:aandm/models/tasklist/dto/create_task_list_dto.dart';
import 'package:aandm/models/note/dto/update_note_dto.dart';

class Backend extends ABackend {
  static final Backend _instance = Backend._privateConstructor();
  factory Backend() => _instance;
  Backend._privateConstructor() {
    super.init();
  }

  Future<TaskList> createTaskList(CreateTaskListDto list) async {
    final body = json.encode(list);
    final res = await post(body, 'task-list/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as Map<String, dynamic>;

      final taskList = TaskList.fromJson(jsonData);

      return taskList;
    } else {
      throw res;
    }
  }

  Future<List<TaskList>> getAllTaskLists() async {
    final res = await get('task-list/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as List<dynamic>;
      var taskLists = <TaskList>[];
      taskLists = jsonData
          .map((e) => TaskList.fromJson(e as Map<String, dynamic>))
          .toList();

      return taskLists;
    } else {
      throw res;
    }
  }

  //updateTaskList
  Future<TaskList> updateTaskList(UpdateTaskListDto taskList) async {
    final body = json.encode(taskList.toJson());
    final res = await put(body, 'task-list/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as Map<String, dynamic>;

      final updatedTaskList = TaskList.fromJson(jsonData);

      return updatedTaskList;
    } else {
      throw res;
    }
  }

  Future<TaskList> deleteTaskList(int id) async {
    final res = await delete('task-list/$id');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as Map<String, dynamic>;

      final taskList = TaskList.fromJson(jsonData);

      return taskList;
    } else {
      throw res;
    }
  }

  Future<Note> createNote(CreateNoteDto note) async {
    final body = json.encode(note.toJson());
    final res = await post(body, 'note/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as Map<String, dynamic>;

      final note = Note.fromJson(jsonData);

      return note;
    } else {
      throw res;
    }
  }

  Future<List<Note>> getAllNotes() async {
    final res = await get('note/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as List<dynamic>;
      var notes = <Note>[];
      notes = jsonData
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
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as Map<String, dynamic>;

      final note = Note.fromJson(jsonData);

      return note;
    } else {
      throw res;
    }
  }

  Future<Note> updateNote(UpdateNoteDto note) async {
    final body = json.encode(note.toJson());
    final res = await put(body, 'note/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as Map<String, dynamic>;

      final updatedNote = Note.fromJson(jsonData);

      return updatedNote;
    } else {
      throw res;
    }
  }

  Future<Note> deleteNote(int id) async {
    final res = await delete('note/$id');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as Map<String, dynamic>;

      final note = Note.fromJson(jsonData);

      return note;
    } else {
      throw res;
    }
  }

  Future<Task> createTask(CreateTaskDto task) async {
    final body = json.encode(task.toJson());
    final res = await post(body, 'task/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as Map<String, dynamic>;

      final createdTask = Task.fromJson(jsonData);

      return createdTask;
    } else {
      throw res;
    }
  }

  Future<List<Task>> getAllTasks() async {
    final res = await get('task/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as List<dynamic>;
      var tasks = <Task>[];
      tasks = jsonData
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      return tasks;
    } else {
      throw res;
    }
  }

  Future<List<Task>> getAllTasksForList(int taskListId) async {
    final res = await get('task/list/$taskListId');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as List<dynamic>;
      var tasks = <Task>[];
      tasks = jsonData
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      return tasks;
    } else {
      throw res;
    }
  }

  Future<Task> updateTask(Task task) async {
    final body = json.encode(task.toJson());
    final res = await put(body, 'task/');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as Map<String, dynamic>;

      final updatedTask = Task.fromJson(jsonData);

      return updatedTask;
    } else {
      throw res;
    }
  }

  Future<Task> deleteTask(int id) async {
    final res = await delete('task/$id');

    if (res.statusCode == 200 || res.statusCode == 201) {
      final jsonData = await json.decode(utf8.decode(res.bodyBytes))['data']
          as Map<String, dynamic>;

      final task = Task.fromJson(jsonData);

      return task;
    } else {
      throw res;
    }
  }
}
