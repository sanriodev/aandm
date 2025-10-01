import 'package:aandm/enum/privacy_mode_enum.dart';

class UpdateNoteDto {
  int id;
  String? title;
  String? content;
  PrivacyMode? privacyMode;

  UpdateNoteDto({
    required this.id,
    this.title,
    this.content,
    this.privacyMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'privacy_mode': privacyMode,
    };
  }
}
