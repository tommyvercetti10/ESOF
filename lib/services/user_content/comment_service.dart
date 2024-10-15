import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/comment.dart';
import '../../model/post.dart';

class CommentService {
  final db = FirebaseFirestore.instance;
  List<Comment> comments = [];

  Future<void> fetchCommentsFrom(String id, bool isUser) async {
    try {
      comments = [];
      QuerySnapshot querySnapshot = await db.collection('comments').orderBy('timestamp', descending: true).get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        if(data["receiverUid"] == id && ((isUser && !data["isPost"]) || (!isUser && data["isPost"]))) comments.add(Comment.fromJSON(data));
      }

    } catch (e) {
      log('Error getting documents: $e');
    }
  }

  Future<void> addComment (Comment comment) async {
    try {
      await db.collection('comments').add(comment.toJSON());

    } catch(e) {
      log('Error adding comment, $e');
    }
  }

  Future<double> getAverageForUser(String uuid) async {
    double sum = 0;
    int aux = 0;
    try {
      QuerySnapshot querySnapshot = await db.collection('comments').get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        if(data["receiverUid"] == uuid) {
          sum += data['rating'] ?? 0;
          aux += data['rating'] != null ? 1 : 0;
        }
      }

    } catch (e) {
      log('Error getting documents: $e');
    }
    if(aux==0) return 0;
    double roundedNumber = double.parse((sum/aux).toStringAsFixed(1));
    return roundedNumber;
  }
}