import 'package:flutter/material.dart';
import 'package:brainshare/services/user_content/post_service.dart';
import 'package:brainshare/view/user_content/posts/post_view.dart';
import '../../../model/post.dart';

class PostsListWidget extends StatefulWidget {
  final String uuid;
  final bool fromUser;
  final String category;

  const PostsListWidget({
    super.key,
    required this.uuid,
    required this.fromUser,
    required this.category
  });

  @override
  State<StatefulWidget> createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends State<PostsListWidget> {
  final PostService postService = PostService();
  late Future<List<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = getPosts();
  }

  Future<List<Post>> getPosts() async {
    if(widget.category != "") {
      await postService.fetchPostsByCategory(widget.category);
    }
    else {
      widget.fromUser ? await postService.fetchPostsFrom(widget.uuid) : await postService.fetchPosts();
    }

    return postService.posts;
  }

  Future<void> refreshPosts() async {
    setState(() {
      postsFuture = getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error.toString()}'),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return RefreshIndicator(
              onRefresh: refreshPosts,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var post = snapshot.data![index];
                  bool shouldDisplayPost = ((widget.category == "" && !widget.fromUser && post.author != widget.uuid) ||
                      (widget.category != "" && post.category == widget.category && post.author != widget.uuid) ||
                      widget.fromUser);
                  return shouldDisplayPost ? PostView(
                    post: post,
                    onDelete: () {
                      PostService().deletePost(post).then((_) {
                        refreshPosts();
                      }).catchError((error) { }
                      );
                    },
                  ) : Container();
                },
              )
          );
        } else {
          return const Center(
            child: Text("No posts found."),
          );
        }
      },
    );
  }

}
