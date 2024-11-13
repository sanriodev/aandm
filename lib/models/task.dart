import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;
  Task(this.title, this.content, this.isDone);

  @HiveField(2)
  bool isDone = false;
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final typeId = 1;

  @override
  Task read(BinaryReader reader) {
    return Task(reader.read(), reader.read(), reader.readBool());
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.write(obj.title);
    writer.write(obj.content);
    writer.writeBool(obj.isDone);
  }
}
