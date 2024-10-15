import 'package:cloud_firestore/cloud_firestore.dart';

/// A message sent in a conversation by a user
class Message {

  final String uid;
  final String sender;
  final Timestamp at;
  final String text;
  final String? file;
  final String? postId;

  // support for read receipts + likes
  List<String>? likes = [];
  Map<String, dynamic>? readBy;

  Message({
    required this.uid,
    required this.sender,
    required this.at,
    required this.text,
    this.file,
    this.postId,
    this.likes,
    this.readBy
  });

  factory Message.fromJSON(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<String> likes;

    if (data['likes'] != null) {
      likes = List<String>.from(data['likes'].map((item) => item.toString()));
    } else {
      likes = [];
    }
    return Message(
        uid: doc.id,
        text: data['text'] ?? '',
        sender: data['sender'] ?? '',
        readBy: data['read_by'] as Map<String, dynamic>?,
        file: data['file'] as String?,
        postId: data['postId'] as String?,
        at: data['at'] as Timestamp,
        likes: likes
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'read_by': readBy,
      'sender' : sender,
      'text' : text,
      'file' : file,
      'postId' : postId,
      'likes': likes,
      'at' : at,
    };
  }
}
