import 'package:brainshare/model/chat.dart';
import 'package:brainshare/services/chat/chat_service.dart';
import 'package:brainshare/view/chat/chat_edit_view.dart';
import 'package:brainshare/view/chat/messages/message_input.dart';
import 'package:brainshare/view/chat/messages/message_widget.dart';
import 'package:brainshare/view/profile/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../model/message.dart';
import '../../model/thread.dart';
import '../utils/profile_image_circular_widget.dart';

class ChatView extends StatefulWidget {

  /// For now, supports both
  final Thread? thread;
  final Chat? chat;

  const ChatView ({
    super.key,
    this.chat,
    this.thread
  });

  @override
  State<ChatView> createState()
  => _ChatViewState();
}

/// Main view for a chat screen
class _ChatViewState extends State<ChatView> {

  late String roomId;
  late String title;
  late String? subtitle;
  late String? iconUrl;

  bool search = false;
  final TextEditingController searchMessage = TextEditingController();
  final ItemScrollController _scrollController = ItemScrollController();
  List<Message> messages = [];
  List<int> searchMatches = [];
  int currentMatchIndex = 0;
  @override
  void initState() {
    super.initState();
    if (widget.chat == null) {
      roomId = widget.thread!.uid;
      title = widget.thread!.title;
      subtitle = widget.thread!.description;
      iconUrl = widget.thread!.icon;
    }
    else {
      roomId = widget.chat!.uid;
      title = widget.chat!.partner.username;
      iconUrl = widget.chat?.partner.photoURL;
    }
  }

  void performSearch(String query) {
    searchMatches.clear();
    if (query.isEmpty) {
      setState(() {});
      return;
    }

    for (int i = 0; i < messages.length; i++) {
      if (messages[i].text.toLowerCase().contains(query.toLowerCase())) {
        searchMatches.add(i);
      }
    }

    if (searchMatches.isNotEmpty) {
      currentMatchIndex = 0;
      jumpToCurrentMatch();
    }

    setState(() {});
  }

  void jumpToCurrentMatch() {
    if (searchMatches.isNotEmpty) {
      _scrollController.scrollTo(
          index: searchMatches[currentMatchIndex],
          duration: const Duration(milliseconds: 250),
          alignment: 0.5
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: search ? Row(
          children: [
            SizedBox(
              height: 50,
              width: 100,
              child: TextField(
                controller: searchMessage,
                decoration: InputDecoration(
                  hintText: "Search message",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      performSearch(searchMessage.text);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 70,
              height: 50,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      search = false;
                    });
                  }, child: const Text("Close")

              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () {
                if (searchMatches.isNotEmpty) {
                  currentMatchIndex--;
                  if (currentMatchIndex < 0) {
                    currentMatchIndex = searchMatches.length - 1;
                  } else {
                    currentMatchIndex %= searchMatches.length;
                  }
                  jumpToCurrentMatch();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: () {
                if (searchMatches.isNotEmpty) {
                  currentMatchIndex++;
                  currentMatchIndex %= searchMatches.length;
                  jumpToCurrentMatch();
                }
              },
            ),


          ],
        ) :
        GestureDetector(
          onTap: () {
            if(widget.thread != null) Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatEditView(thread: widget.thread!)));
          },
          child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(onPressed: () {
                    if(context.mounted && widget.chat != null) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileView(uuid: widget.chat!.partner.uuid)));
                    }
                  },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.zero
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: (iconUrl == null || iconUrl == "")
                        ? (widget.thread != null && widget.thread!.members.length > 1)
                        ? Stack(
                      children: <Widget>[
                        Positioned(
                          child: SizedBox(
                            width: 49,
                            height: 49,
                            child: profileWidget (
                                photoURL: widget.thread!.members[0].photoURL,
                                width: 49,
                                height: 49,
                                size: 49
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          child: SizedBox (
                            width: 49,
                            height: 49,
                            child: profileWidget (
                                photoURL: widget.thread!.members[1].photoURL,
                                width: 49,
                                height: 49,
                                size: 49
                            ),
                          ),
                        ),
                      ],
                    )
                        : const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 30
                    )
                        : Image.network(
                        iconUrl!,
                        fit: BoxFit.cover
                    ),

                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(title.length > 10 ? '${title.substring(0,10)}...' : title)
                ),
                const Spacer(),
                IconButton(onPressed: () {
                  setState(() {
                    search = true;
                  });
                },
                    icon: const Icon(Icons.search)
                )
              ]
          ),
        )
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ChatService().getMessages(FirebaseFirestore.instance.collection("chats").doc(roomId)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return const Text("No messages found.");
                  }

                  messages = snapshot.data!.docs.map((doc) => Message.fromJSON(doc)).toList();

                  return ScrollablePositionedList.builder(
                    itemScrollController: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      return FutureBuilder<Widget>(
                          future: message.postId != null && message.postId!.isNotEmpty
                              ?  messagePostWidget(context, snapshot.data!.docs[index])
                              : messageWidget(context, snapshot.data!.docs[index]),
                          builder: (context, asyncSnapshot) {
                            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            return asyncSnapshot.hasData
                                ? asyncSnapshot.data!
                                : const Text("Error loading message.");
                          }
                      );
                    },
                  );
                },
              )
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: messageInputWidget(roomId, context),
          )

        ],
      ),
    );
  }
}