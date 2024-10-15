import 'package:brainshare/services/auth/auth_service.dart';
import 'package:brainshare/services/auth/auth_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/thread.dart';
import '../../services/chat/chat_service.dart';
import '../chat/chat_header.dart';
import '../chat/chat_screen.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  List<AuthUser> selectedUsers = [];
  List<String> chattingWithUserIds = [];

  @override
  void initState() {
    super.initState();
    _fetchChattingWithUserIds();
  }

  Future<void> _fetchChattingWithUserIds() async {
    String? userId = AuthService.firebase().currentUser?.uid;
    if (userId != null) {
      ChatService().getChats(userId).listen((snapshot) {
        List<String> userIds = [];
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if(data['thread']==true) continue;
          List<dynamic> members = data['members'];
          for (var member in members) {
            if (member != userId && !userIds.contains(member)) {
              userIds.add(member);
            }
          }
        }
        setState(() {
          chattingWithUserIds = userIds;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData) {
            return const Text("No users found");
          }

          List<DocumentSnapshot> docs = snapshot.data!.docs;

          List<Widget> userList = docs.map<Widget>((doc) {
            Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
            if (json["uuid"] != AuthService.firebase().currentUser!.uid &&
                !chattingWithUserIds.contains(json["uuid"])) {
              AuthUser user = AuthUser.fromJSON(json);
              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    if (selectedUsers.contains(user)) {
                      selectedUsers.remove(user);
                    } else {
                      selectedUsers.add(user);
                    }
                  });
                },
                onTap: () {
                  setState(() {
                    if (selectedUsers.contains(user)) {
                      selectedUsers.remove(user);
                    } else if (selectedUsers.isNotEmpty) {
                      selectedUsers.add(user);
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return FutureBuilder(
                              future: ChatService().createChat(user),
                              builder:
                                  (BuildContext context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                return ChatView(chat: snapshot.data!);
                              },
                            );
                          }));
                    }
                  });
                },
                child: preChatWidget(context, user, selectedUsers),
              );
            }
            return Container();
          }).toList();

          return Material(
            child: ListView(
              children: userList,
            ),
          );
        },
      ),
      floatingActionButton: selectedUsers.isNotEmpty
          ? FloatingActionButton(
        onPressed: () async {
          String? userId = AuthService.firebase().currentUser?.uid;
          AuthUser? userAsAuthUser =
          await AuthService.firebase().getUser(userId!);
          selectedUsers.add(userAsAuthUser!); // add current user to thread members

          String title = userAsAuthUser.username;

          title += ", ";
          title += selectedUsers.first.username;

          if (selectedUsers.length > 2) {
            title += " +";
            title += (selectedUsers.length - 2).toString();
            title += " others";
          }

          Thread t = await ChatService()
              .createThread(title, null, selectedUsers);
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ChatView(thread: t)),
                  (route) => route.isFirst,
            );
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.arrow_forward),
      )
          : null,
    );
  }
}
