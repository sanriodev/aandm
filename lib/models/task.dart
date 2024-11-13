import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  bool isDone = false;

  @HiveField(3)
  int taskListId;

  Task(this.title, this.content, this.isDone, this.taskListId);
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final typeId = 1;

  @override
  Task read(BinaryReader reader) {
    return Task(reader.readString(), reader.readString(), reader.readBool(),
        reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.content);
    writer.writeBool(obj.isDone);
    writer.writeInt(obj.taskListId);
  }
}
