import 'dart:async';
import 'dart:collection';
import '../model/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatCache {

  static final Map<String, Chat> _chatCache = HashMap();
  static final Map<String, Chat> _threadCache = HashMap();

  static StreamSubscription listenForChanges(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((data) async {
          for (var tmp in data.docChanges) {
            String id = tmp.doc.id;
            switch (tmp.type) {
              case DocumentChangeType.removed:
                // message deleted
                if (_chatCache.containsKey(id)) {
                  _chatCache.remove(id);
                }
                break;
              case DocumentChangeType.modified:
              case DocumentChangeType.added:
                // message added/ modified
                _chatCache[id] = await Chat.fromJSON(tmp.doc);
            }
          }
        });
  }
}
