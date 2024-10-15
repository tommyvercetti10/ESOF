import 'package:brainshare/model/thread.dart';
import 'package:brainshare/services/auth/auth_user.dart';
import 'package:brainshare/view/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import '../../model/chat.dart';
import '../utils/profile_image_circular_widget.dart';

Widget threadWidget(BuildContext context, Thread thread, bool isSelected) {
  return ListTile(
    tileColor: isSelected ? Colors.blue[100] : null,
    leading: Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
      child:SizedBox(
        // beware of this value
        // might cut off images
        width: (thread.icon == null && thread.members.length > 1) ? 72 : 50,
        child: Stack(
          children: <Widget>[
            if (thread.icon != null)
              Positioned(
                child: SizedBox(
                  width: 49,
                  height: 49,
                  child: profileWidget (
                      photoURL: thread.icon,
                      width: 49,
                      height: 49,
                      size: 49
                  ),
                ),
              ),
            if (thread.icon == null)
              Positioned(
                child: SizedBox(
                  width: 49,
                  height: 49,
                  child: profileWidget (
                      photoURL: thread.members[0].photoURL,
                      width: 49,
                      height: 49,
                      size: 49
                  ),
                ),
              ),
            // add a second member to icon
            if (thread.icon == null && thread.members.length > 1)
              Positioned(
                left: 25,
                child: SizedBox (
                  width: 49,
                  height: 49,
                  child: profileWidget (
                      photoURL: thread.members[1].photoURL,
                      width: 49,
                      height: 49,
                      size: 49
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
    title: Text(
        thread.title,
        style: const TextStyle (
            fontSize: 17
        )
    ),
    subtitle: thread.description != null && thread.description!.length > 37
        ? Text('${thread.description!.substring(0, 37)}...')
        : thread.description != null
        ? Text(thread.description!)
        : null,
    //---------
    // events
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChatView (thread: thread);
      })
      );
    },
  );
}

Widget chatWidget(BuildContext context, Chat chat, bool isSelected) {
  return ListTile(
    tileColor: isSelected ? Colors.blue[100] : null,
    leading: Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
      child:SizedBox(
        width: 50,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: SizedBox(
                width: 49,
                height: 49,
                child: profileWidget (
                    photoURL: chat.partner.photoURL,
                    width: 49,
                    height: 49,
                    size: 49
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    title: Text(
        chat.partner.username,
        style: const TextStyle (
            fontSize: 17,
            color: Colors.black
        )
    ),
    //---------
    // events
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChatView (chat: chat);
      })
      );
    },
  );
}

Widget preChatWidget(BuildContext context, AuthUser user2, List<AuthUser> selectedUsers) {
  return Container(
    color: selectedUsers.contains(user2) ? Colors.blue[100] : null,
    child: ListTile(
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
        child: SizedBox(
          width: 50,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: SizedBox(
                  width: 49,
                  height: 49,
                  child: profileWidget (
                      photoURL: user2.photoURL,
                      width: 49,
                      height: 49,
                      size: 49
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      title: Text(
          user2.username,
          style: const TextStyle (
              fontSize: 17,
              color: Colors.black
          )
      ),
      // onTap: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return FutureBuilder(
      //         future: ChatService().createChat(user2),
      //         builder: (BuildContext context, AsyncSnapshot snapshot) {
      //           if (!snapshot.hasData) {
      //             return const CircularProgressIndicator();
      //           }
      //           return ChatView(chat: snapshot.data!);
      //         },
      //       );
      //     })
      //     );
      // },
    ),
  );
}
