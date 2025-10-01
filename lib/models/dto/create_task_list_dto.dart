import 'package:aandm/models/enum/privacy_mode_enum.dart';

class CreateTaskListDto {
  String name;
  PrivacyMode? privacyMode;

  CreateTaskListDto({
    required this.name,
    this.privacyMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'privacyMode': privacyMode,
    };
  }
}
