import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  String? description;

  Task(
      {required this.title,
      required this.content,
      required this.isDone,
      this.description});
}
