import 'package:aandm/models/task.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class TaskList extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList<Task>? tasks;

  TaskList(this.name);
}

class TaskListAdapter extends TypeAdapter<TaskList> {
  @override
  final typeId = 0;

  @override
  TaskList read(BinaryReader reader) {
    return TaskList(reader.read());
  }

  @override
  void write(BinaryWriter writer, TaskList obj) {
    writer.write(obj.name);
    writer.write(obj.tasks);
  }
}
