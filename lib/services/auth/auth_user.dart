import 'package:flutter/cupertino.dart';

class AuthUser with ChangeNotifier {

  late String uuid;
  late String username;
  late String photoURL;
  late String? bio;
  late String status;
  bool? isModerator = false;
  bool? isBanned = false;
  late String? cvURL;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthUser && uuid == other.uuid;
  }

  AuthUser({
    required this.uuid,
    required this.username,
    required this.photoURL,
    this.bio,
    required this.status,
    this.isModerator,
    this.isBanned,
    this.cvURL,
  });

  void updateUser(AuthUser user) {
    status = user.status;
    bio = user.bio;
    photoURL = user.photoURL;
    isModerator = user.isModerator;
    cvURL = user.cvURL;
  }

  AuthUser.fromJSON(Map<String, dynamic> json) {
    uuid = json["uuid"];
    username = json["username"];
    photoURL = json["photoURL"] ?? "";
    bio = json["bio"] ?? "";
    status = json["status"] ?? "";
    isModerator = json["isModerator"] ?? false;
    isBanned = json["isBanned"] ?? false;
    cvURL = json["cvURL"] ?? "";
  }
}