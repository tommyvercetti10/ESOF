import 'package:brainshare/view/chat_list/active_chats_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/chat.dart';
import '../../model/thread.dart';
import '../../services/auth/auth_service.dart';
import '../../services/chat/chat_service.dart';

import '../chat/chat_header.dart';
import 'chat_userlist.dart';

class ActiveChatsView extends StatefulWidget {

  const ActiveChatsView({super.key});

  @override
  State<ActiveChatsView> createState() => _ActiveChatsViewState();
}

/// Display active chats for a user
/// (both private and threads)
class _ActiveChatsViewState extends State<ActiveChatsView> {

  final String userId = AuthService.firebase().currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatsView()),
                  );
                }
              },
            ),
          ],
        ),
        body: ActiveChatsList(userId: userId, onThreadSelection: (String a) {}, selectable: false) // ignore the parameter function
    );
  }
}
