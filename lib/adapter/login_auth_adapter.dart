import 'package:aandm/models/auth/login_response_model.dart';
import 'package:hive/hive.dart';

class LoginAuthAdapter extends TypeAdapter<LoginResponse> {
  @override
  final int typeId = 9;

  @override
  LoginResponse read(BinaryReader reader) {
    return LoginResponse(
      accessToken: reader.readString(),
      refreshToken: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, LoginResponse obj) {
    writer.writeString(obj.accessToken);
    writer.writeString(obj.refreshToken);
  }
}
