import 'package:aandm/models/base/login_response_model.dart';
import 'package:aandm/models/base/login_response_user.dart';
import 'package:hive/hive.dart';

class LoginAuthAdapter extends TypeAdapter<LoginResponse> {
  @override
  final int typeId = 9;

  @override
  LoginResponse read(BinaryReader reader) {
    final accessToken = reader.readString();
    final refreshToken = reader.readString();

    LoginResponseUser? user;
    // Backward-compatible read: older entries only have two strings.
    // Try to read a presence flag + map; if unavailable, user stays null.
    try {
      final hasUser = reader.readBool();
      if (hasUser) {
        final raw = reader.read();
        if (raw is Map) {
          final map = raw.cast<String, dynamic>();
          user = LoginResponseUser.fromJson(map);
        }
      }
    } catch (_) {
      // No more bytes or different layout; leave user as null.
    }

    return LoginResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }

  @override
  void write(BinaryWriter writer, LoginResponse obj) {
    writer.writeString(obj.accessToken);
    writer.writeString(obj.refreshToken);
    // Write a presence flag for user, then write a serializable map.
    if (obj.user != null) {
      writer.writeBool(true);
      writer.write(obj.user!.toJson());
    } else {
      writer.writeBool(false);
    }
  }
}
