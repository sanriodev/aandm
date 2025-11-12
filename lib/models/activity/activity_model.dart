class EventlogMessage<T> {
  final String actionType;
  final String entityType;
  final String entityId;
  // final EntityEvent<T> data;
  final String actionStatus;
  final DateTime date;
  final AcitvityUser user;
  // final User? auth;

  EventlogMessage({
    required this.actionType,
    required this.entityType,
    required this.entityId,
    // required this.data,
    required this.actionStatus,
    required this.date,
    required this.user,
    // this.auth,
  });

  factory EventlogMessage.fromJson(Map<String, dynamic> json) {
    return EventlogMessage(
      actionType: json['actionType'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      actionStatus: json['actionStatus'] as String,
      user: AcitvityUser.fromJson(json['user'] as Map<String, dynamic>),
      date: DateTime.parse(json['date'] as String),

      // auth: json['auth'] != null
      //     ? User.fromJson(json['auth'] as Map<String, dynamic>)
      //     : null,
    );
  }
}

class EntityEvent<T> {
  T? pre;
  T? post;
  T? entity;
}

class AcitvityUser {
  String username;
  int id;

  AcitvityUser({required this.username, required this.id});

  factory AcitvityUser.fromJson(Map<String, dynamic> json) {
    return AcitvityUser(
      username: json['username'] as String,
      id: json['id'] as int,
    );
  }
}
