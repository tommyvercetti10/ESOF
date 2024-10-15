import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/chat.dart';
import '../../model/thread.dart';
import '../../services/chat/chat_service.dart';
import '../chat/chat_header.dart';

class ActiveChatsList extends StatefulWidget {
  final String userId;
  final Function(String) onThreadSelection;
  final bool selectable;
  const ActiveChatsList({super.key, required this.userId, required this.onThreadSelection, required this.selectable});

  @override
  _ActiveChatsListState createState() => _ActiveChatsListState();
}

class _ActiveChatsListState extends State<ActiveChatsList> {
  String? selectedThreadId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatService().getChats(widget.userId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No active conversations!');
        }

        List<DocumentSnapshot> userChats = snapshot.data!.docs;

        return ListView.builder(
          itemCount: userChats.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = userChats[index];

            return FutureBuilder<dynamic>(
              future: (doc['thread'] == true) ? Thread.fromJSON(doc) : Chat.fromJSON(doc),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Text('Could not fetch conversation!');
                }
                return GestureDetector(
                  onLongPress: () {
                    if(widget.selectable) {
                      setState(() {
                        selectedThreadId = snapshot.data!.uid;
                      });
                      widget.onThreadSelection(snapshot.data!.uid);
                    }
                  },
                  child: snapshot.data is Thread
                      ? threadWidget(context, snapshot.data as Thread, (snapshot.data as Thread).uid == selectedThreadId)
                      : chatWidget(context, snapshot.data as Chat, (snapshot.data as Chat).uid == selectedThreadId),
                );
              },
            );
          },
        );
      },
    );
  }
}
