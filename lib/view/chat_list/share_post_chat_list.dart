import 'package:brainshare/services/auth/auth_service.dart';
import 'package:brainshare/services/chat/chat_service.dart';
import 'package:brainshare/view/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/post.dart';
import '../../services/auth/auth_user.dart';
import 'active_chats_list.dart';

class SharePostChatList extends StatefulWidget {
  final Post post;
  const SharePostChatList({super.key, required this.post});

  @override
  State<SharePostChatList> createState() => _SharePostChatListState();
}

class _SharePostChatListState extends State<SharePostChatList> {
  String? selectedThreadId;
  User? user = AuthService.firebase().currentUser;
  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Post'),
        actions: [
          if (selectedThreadId != null)
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                ChatService().sendMessage(FirebaseFirestore.instance.collection("chats").doc(selectedThreadId), "", null, widget.post);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
      body: ActiveChatsList(userId: user!.uid, onThreadSelection: (String threadId) {
              setState(() {
                selectedThreadId = threadId;
              });
            }, selectable: true
      ),
    );
  }
}
