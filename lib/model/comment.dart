import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Comment {
  late String author;
  late String receiverUid;
  late bool isPost;
  late String text;
  late Timestamp timestamp;
  late double rating;

  Comment(this.author, this.text, this.rating, this.receiverUid, this.isPost) {
    timestamp = Timestamp.now();
  }

  Comment.fromJSON(Map<String, dynamic> json) {
    author = json["author"];
    text = json["text"];
    isPost = json["isPost"] ?? false;
    receiverUid = json["receiverUid"];
    if (json["timestamp"] is Timestamp) {
      timestamp = json["timestamp"];
    } else if (json["timestamp"] is String) {
      timestamp = Timestamp.fromDate(parseDateString(json["timestamp"]));
    } else {
      throw const FormatException('Timestamp is not in a recognizable format');
    }
    rating = json['rating'] ?? 0;
  }

  Map<String, dynamic> toJSON() {
    return {
      "author": author,
      "receiverUid" : receiverUid,
      "isPost" : isPost,
      "text": text,
      "timestamp": timestamp,
      "rating": rating,
    };
  }

  DateTime parseDateString(String dateString) {
    return DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(dateString);
  }

}
