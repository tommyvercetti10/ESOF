import 'package:flutter/material.dart';
import '../../../model/comment.dart';
import '../../../services/user_content/comment_service.dart';
import 'comments_view.dart';

Widget commentsListWidget(String id, bool isUser) {
  final CommentService commentService = CommentService();


  Future<List<Comment>> getComments() async {
    await commentService.fetchCommentsFrom(id, isUser);
    return commentService.comments;
  }

  return FutureBuilder(
    future: getComments(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error.toString()}'),
        );
      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        return RefreshIndicator(
            onRefresh: () async {
              await getComments();
            },
            child: ListView.builder(
                itemCount: commentService.comments.length,
                itemBuilder: (context, index) {
                  return CommentView(comment: commentService.comments[index]);
                },
              ),
        );
      } else {
        return const Center(
          child: Text("No Comments found."),
        );
      }
    },
  );
}
