import 'package:aandm/enum/privacy_mode_enum.dart';

class UpdateTaskListDto {
  int id;
  String? name;
  PrivacyMode? privacyMode;

  UpdateTaskListDto({
    required this.id,
    this.name,
    this.privacyMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'privacyMode': privacyMode,
    };
  }
}
