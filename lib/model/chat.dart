import 'package:brainshare/services/auth/auth_service.dart';
import 'package:brainshare/storage/user_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth/auth_user.dart';

/// A 1-to-1 chat between two users
class Chat {

  final String uid;
  final String creator;
  final Timestamp creation;
  final AuthUser partner;

  Chat ({
    required this.uid,
    required this.creator,
    required this.creation,
    required this.partner
  });

  Map<String, dynamic> toJSON() {
    // parse members
    String userId = AuthService.firebase().currentUser!.uid;
    final List<String> memberIds = [userId, partner.uuid];
    return {
      'thread': false,
      'creator': creator,
      'members': memberIds,
      'creation_date' : creation
    };
  }

  static Future<Chat> fromJSON(DocumentSnapshot doc) async {

    AuthUser? partner;

    for (String id in List.from(doc['members'])) {
      if (id != AuthService.firebase().currentUser!.uid) {
        // fetch partner from uuid
        partner = await UserCache.get(id);
        break;
      }
    }

    if (partner == null) {
      throw Exception("User not found mid retrieval");
    }

    return Chat (
      uid: doc.id,
      partner: partner,
      creator: doc['creator'],
      creation: doc['creation_date'],
    );
  }
}



