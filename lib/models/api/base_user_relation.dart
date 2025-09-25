import 'package:aandm/models/auth/user_model.dart';

class BaseUserRelation {
  User user;
  User lastModifiedUser;

  BaseUserRelation({
    required this.user,
    required this.lastModifiedUser,
  });
}
