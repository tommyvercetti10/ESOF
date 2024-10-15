import 'package:brainshare/services/auth/auth_service.dart';
import 'package:brainshare/services/user_content/post_service.dart';
import 'package:brainshare/view/user_content/posts/post_full_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../model/message.dart';
import '../../../model/post.dart';
import '../../../services/auth/auth_user.dart';
import '../../utils/profile_image_circular_widget.dart';
import 'message_dialog.dart';

Future<Widget> messageWidget(BuildContext context, DocumentSnapshot doc)  async {
  Message message = Message.fromJSON(doc);
  final AuthUser? user = await AuthService.firebase().getUser(message.sender);
  final AuthUser? currentUser = await AuthService.firebase().getUser(AuthService.firebase().currentUser!.uid);
  final photoURL = user?.photoURL ?? "";
  bool isFromOtherUser = message.sender != AuthService.firebase().currentUser!.uid;
  return GestureDetector(
    onLongPress: () async {
      await showMessageDialog(context, doc, currentUser!);
    },
    child: Row(
      mainAxisAlignment: isFromOtherUser ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        isFromOtherUser ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ClipOval(
            child: SizedBox(
                width: 30,
                height: 30,
                child: Container(
                    child: photoURL != "" ? Image.network(photoURL) : const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 30
                    )
                )
            ),
          ),
        ) : Container(),
        Stack(
          children: [
          Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isFromOtherUser ? const Color.fromARGB(255, 1, 54, 89) : const Color.fromARGB(255, 216, 216, 216),
              ),
              width: 100,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      if(message.file != "" && message.file != null) Image.network(message.file ?? "", height: 70),
                      Text(message.text,
                          softWrap: true,
                          style: TextStyle(
                              color: isFromOtherUser ?
                              const Color.fromARGB(255, 255, 255, 255) :
                              const Color.fromARGB(255, 0, 0, 0)
                          )
                      ),
                    ],
                  )
              )
          ),
        ),
            thumbsUp(message, isFromOtherUser, 100)
          ],
        ),
      ],
    ),
  );
}


Future<Widget> messagePostWidget(BuildContext context, DocumentSnapshot doc) async {
  Message message = Message.fromJSON(doc);
  PostService postService = PostService();

  await postService.fetchPostsById(message.postId!);

  Post post = postService.posts.first;
  final AuthUser? user = await AuthService.firebase().getUser(post.author);
  final AuthUser? currentUser = await AuthService.firebase().getUser(AuthService.firebase().currentUser!.uid);
  bool isFromOtherUser = message.sender != AuthService.firebase().currentUser!.uid;

  return Align(
    alignment: isFromOtherUser ? Alignment.centerLeft : Alignment.centerRight,
    child: GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostFullView(post: post)));
        },
        onLongPress: () async {
          await showMessageDialog(context, doc, currentUser!);
        },
        child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isFromOtherUser ? const Color.fromARGB(255, 1, 54, 89) : const Color.fromARGB(255, 216, 216, 216),
                      ),
                      width: 150,
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  profileWidget(width: 20, height: 20, size: 20, photoURL: user?.photoURL ?? ''),
                                  const SizedBox(width: 10),
                                  Text(
                                    softWrap: true,
                                    user?.username ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold)

                                  ),
                                ],
                              ),
                              Text(post.text,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: isFromOtherUser ?
                                      const Color.fromARGB(255, 255, 255, 255) :
                                      const Color.fromARGB(255, 0, 0, 0)
                                  )
                              ),
                            ],
                          )
                      )
                  )
              ),
              thumbsUp(message, isFromOtherUser, 150)
            ]
        )
    )
  );
}


Widget thumbsUp(Message message, bool isFromOtherUser, double width) {
  return Positioned(
    bottom: 0,
    right: isFromOtherUser? -1: width,
    child: Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(6),
      child:
      Row(children: [
        Text("${message.likes?.isEmpty ?? true ? "" : message.likes?.length}"),
        const Icon(Icons.thumb_up_alt_rounded, size: 20, color: Colors.orangeAccent),
      ],),
    ),
  );
}