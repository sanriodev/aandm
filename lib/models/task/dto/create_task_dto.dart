class CreateTaskDto {
  String title;
  String? content;
  int taskListId;

  CreateTaskDto({
    required this.title,
    required this.taskListId,
    this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'taskListId': taskListId,
    };
  }
}
