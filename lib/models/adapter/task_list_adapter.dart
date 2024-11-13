import 'package:aandm/models/task.dart';
import 'package:aandm/models/task_list.dart';
import 'package:hive/hive.dart';

class TaskListAdapter extends TypeAdapter<TaskList> {
  @override
  final int typeId = 1;

  @override
  TaskList read(BinaryReader reader) {
    return TaskList(
        name: reader.readString(),
        tasks: reader.readHiveList().castHiveList<Task>());
  }

  @override
  void write(BinaryWriter writer, TaskList obj) {
    writer.writeString(obj.name);
    writer.writeHiveList(obj.tasks);
  }
}
