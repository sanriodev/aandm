import 'package:aandm/models/hive_interface.dart';
import 'package:hive/hive.dart';

@Deprecated("Old Hive model to store as nosql on device")
@HiveType(typeId: 2)
class Note extends HiveObject with HiveModel {
  @override
  @HiveField(0)
  // ignore: overridden_fields
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String content;

  Note(this.id, this.name, this.content);
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 2;

  @override
  Note read(BinaryReader reader) {
    return Note(reader.readInt(), reader.readString(), reader.readString());
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.content);
  }
}
