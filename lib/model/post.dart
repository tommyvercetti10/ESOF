import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class Post {
  late String id;
  late String author;
  late String text;
  late Timestamp timestamp;
  late List<String> likes;
  late String category;

  Post(String user, this.text, this.category) {
    author = user;
    timestamp = Timestamp.now();
    likes = [];
  }

  Post.fromJSON(Map<String, dynamic> json, this.id) {
    author = json["author"];
    text = json["text"];
    if (json["timestamp"] is Timestamp) {
      timestamp = json["timestamp"];
    } else if (json["timestamp"] is String) {
      timestamp = Timestamp.fromDate(parseDateString(json["timestamp"]));
    } else {
      throw const FormatException('Timestamp is not in a recognizable format');
    }
    if (json['likes'] != null) {
      likes = List<String>.from(json['likes'].map((item) => item.toString()));
    } else {
      likes = [];
    }
    category = json['category'] ?? "";
  }

  Map<String, dynamic> toJSON() {
    return {
      "author": author,
      "text": text,
      "timestamp": timestamp,
      "likes": likes,
      "category": category
    };
  }
  DateTime parseDateString(String dateString) {
    return DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(dateString);
  }
}
