import 'package:brainshare/view/user_content/comments/comments_list_view.dart';
import 'package:brainshare/view/user_content/posts/post_view.dart';
import 'package:flutter/material.dart';

import '../../../model/post.dart';
import '../../../services/user_content/post_service.dart';

class PostFullView extends StatefulWidget {
  final Post post;
  const PostFullView({super.key, required this.post});

  @override
  State<PostFullView> createState() => _PostFullViewState();
}

class _PostFullViewState extends State<PostFullView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // just to have the arrow back :)
      ),
      body: Column(
          children: [
            PostView(post: widget.post, onDelete: () {
              PostService().deletePost(widget.post).then((_) {
                if(context.mounted) {
                  Navigator.of(context).pop();
                }
              }).catchError((error) { }
              );
            }),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: commentsListWidget(widget.post.id, false),
                )
            )
          ],
        ),
    );
  }
}


