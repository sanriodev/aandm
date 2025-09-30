class CreateNoteDto {
  String title;
  String? content;

  CreateNoteDto({
    required this.title,
    this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
