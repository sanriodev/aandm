import 'dart:convert';

import 'package:aandm/backend/abstract/backend_abstract.dart';
import 'package:aandm/models/api/task_list_api_model.dart';

class Backend extends ABackend {
  static final Backend _instance = Backend._privateConstructor();
  factory Backend() => _instance;
  Backend._privateConstructor() {
    super.init();
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
}
