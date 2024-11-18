import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  Note(this.title, this.content);
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 3;

  @override
  Note read(BinaryReader reader) {
    return Note(reader.readString(), reader.readString());
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.content);
  }
}
