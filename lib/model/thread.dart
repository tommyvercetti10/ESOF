import 'package:brainshare/storage/user_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth/auth_service.dart';
import '../services/auth/auth_user.dart';

/// A conversation thread between users
class Thread {

  final String uid;
  final String creator;
  final Timestamp creation;
  final List<AuthUser> members;

  final String? icon;
  final String title;
  final String? description;
  final List<String>? admins;

  Thread ({
    required this.uid,
    required this.creator,
    required this.creation,
    required this.members,
    required this.title,
    this.description,
    this.admins,
    this.icon
  });

  Map<String, dynamic> toJSON() {
    // parse members
    final List<String> ids = [];
    for (AuthUser u in members) {
      ids.add(u.uuid);
    }
    return {
      'thread': true,
      'icon': icon,
      'title': title,
      'members': ids,
      'creator': creator,
      'creation_date' : creation,
      'description': description,
      'admins': admins
    };
  }

  static Future<Thread> fromJSON(DocumentSnapshot doc) async {

    List<AuthUser> members = [];
    List<String> memberIds = List.from(doc['members']);

    for (String id in memberIds) {
      // fetch members from uuid
      AuthUser? u = await UserCache.get(id);
      if (u == null) {
        throw Exception("Failed to fetch user mid retrieval");
      }
      members.add(u);
    }

    return Thread (
        uid: doc.id,
        members: members,
        icon: doc['icon'],
        title: doc['title'],
        creator: doc['creator'],
        creation: doc['creation_date'],
        description: doc['description'],
        admins: List.from(doc['admins'])
    );
  }
}
