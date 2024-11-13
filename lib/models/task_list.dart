import 'package:hive/hive.dart';
import 'task.dart';

@HiveType(typeId: 1)
class TaskList extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList<Task> tasks;

  TaskList({required this.name, required this.tasks});
}
