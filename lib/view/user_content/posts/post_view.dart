import 'package:brainshare/services/user_content/comment_service.dart';
import 'package:brainshare/services/user_content/post_service.dart';
import 'package:brainshare/view/chat_list/share_post_chat_list.dart';
import 'package:brainshare/view/user_content/posts/post_full_view.dart';
import 'package:brainshare/view/utils/profile_image_circular_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brainshare/view/user_content/posts/post_dialog_view.dart';
import '../../../model/utils/date_utils.dart' as date;
import '../../../model/post.dart';
import '../../../model/comment.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/auth/auth_user.dart';

class PostView extends StatefulWidget {
  final Post post;
  final VoidCallback onDelete;


  const PostView({
    super.key,
    required this.post,
    required this.onDelete
  });

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool isLoading = true;
  AuthUser? user;
  AuthUser? currentUser;
  bool hasLiked = false;
  bool isReplying = false;

  final TextEditingController _postText = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeUsers();
  }


  void createComment() async {
    String text = _postText.text;

    Comment comment = Comment(currentUser!.uuid, text, 0, widget.post.id, true);
    CommentService().addComment(comment);
    _postText.clear();
  }


  Future<void> initializeUsers() async {
    currentUser = await AuthService.firebase().getUser(AuthService.firebase().currentUser!.uid);
    user = await AuthService.firebase().getUser(widget.post.author);
    if (mounted) {
      setState(() {
        hasLiked = widget.post.likes.contains(currentUser?.uuid);
        isLoading = false;
      });
    }
  }

  void toggleReply() {
    setState(() {
      isReplying = !isReplying;
    });
  }

  void sendReply() {
    print('Resposta: ${_postText.text}');
    setState(() {
      isReplying = false;
      _postText.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    String timeSince = date.DateUtils.getDeltaTime(widget.post.timestamp);
    ThemeData themeData = Theme.of(context);

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostFullView(post: widget.post)));
      },
      child: Container(
        color: themeData.scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                profileWidget(width: 20, height: 20, size: 20, photoURL: user?.photoURL ?? ''),
                const SizedBox(width: 10),
                Text(
                  user?.username ?? '',
                  style: themeData.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if(widget.post.category != "") Container(
                  margin: const EdgeInsets.only(left: 10, right: 20),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(220, 220, 220, 0.5)
                  ),
                  child: Text(widget.post.category),
                ),
                const Spacer(),
                Text(
                  timeSince,
                  style: themeData.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
                if (user?.uuid == currentUser?.uuid || (user?.uuid != currentUser?.uuid && (currentUser?.isModerator ?? false) && !(user?.isModerator ?? false)))
                  IconButton(
                      onPressed: () async {
                        await showPostDialog(context, widget.post, currentUser!, user!, widget.onDelete);
                      },
                      icon: const Icon(Icons.more_vert_rounded)
                  )

              ],
            ),
            Row(
              children: [
                Text(
                  widget.post.text,
                  style: themeData.textTheme.bodyMedium,
                ),
              ],
            ),
            Row(
              children: [
                IconButton(onPressed: () {
                  if(!hasLiked) {
                    PostService().likePost(widget.post, currentUser!);
                    setState(() {
                      hasLiked = true;
                    });
                  }
                  else {
                    PostService().dislikePost(widget.post, currentUser!);
                    setState(() {
                      hasLiked = false;
                    });
                  }
                }, icon: Icon(IconData(hasLiked ? 0xf443 : 0xf442, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage))),
                IconButton(onPressed: toggleReply, icon: const Icon(Icons.comment)),
                IconButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SharePostChatList(post: widget.post)));
                }, icon: const Icon(Icons.share))
              ],
            ),
            if (isReplying)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _postText,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Add a comment',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                        border: InputBorder.none,

                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: createComment,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
