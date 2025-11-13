import 'package:blvckleg_dart_core/models/user/user_model.dart';

class BaseUserRelation {
  User? user;
  User? lastModifiedUser;

  BaseUserRelation({
    this.user,
    this.lastModifiedUser,
  });
}
