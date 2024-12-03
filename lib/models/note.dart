import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Note extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String content;

  Note(this.name, this.content);
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 2;

  @override
  Note read(BinaryReader reader) {
    return Note(reader.readString(), reader.readString());
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.content);
  }
}
