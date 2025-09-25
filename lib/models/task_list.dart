import 'package:aandm/models/hive_interface.dart';
import 'package:aandm/models/task.dart';
import 'package:hive/hive.dart';

@Deprecated("Old Hive model to store as nosql on device")
@HiveType(typeId: 0)
class TaskList extends HiveObject with HiveModel {
  @HiveField(0)
  String name;

  @override
  @HiveField(1)
  // ignore: overridden_fields
  int id;

  TaskList(this.name, this.id);
}

class TaskListAdapter extends TypeAdapter<TaskList> {
  @override
  final typeId = 0;

  @override
  TaskList read(BinaryReader reader) {
    return TaskList(reader.readString(), reader.readInt());
  }

  @override
  void write(BinaryWriter writer, TaskList obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.id);
  }
}

class TaskListWithTasks {
  final TaskList taskList;
  final List<Task> tasks;

  TaskListWithTasks(this.taskList, this.tasks);
}
