import 'package:brainshare/services/chat/chat_service.dart';
import 'package:brainshare/view/chat/chat_screen.dart';
import 'package:brainshare/view/chat_list/active_chats.dart';
import 'package:brainshare/view/chat_list/chat_userlist.dart';
import 'package:brainshare/view/utils/profile_image_circular_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../model/thread.dart';

class ChatEditView extends StatefulWidget {

  final Thread thread;
  const ChatEditView({super.key, required this.thread});

  @override
  State<ChatEditView> createState() => _ChatEditViewState();
}

class _ChatEditViewState extends State<ChatEditView> {
  File? imageFile;
  late final TextEditingController _description;
  late final TextEditingController _title;
  late String icon;
  late String title;
  late String? description;

  @override
  void initState() {
    _description = TextEditingController();
    _title = TextEditingController();
    icon = widget.thread.icon ?? "";
    title = widget.thread.title;
    description = widget.thread.description ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: selectImage,
              child: Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 10),
                  child: profileWidget(photoURL: icon, width: 120, height: 120, size: 50)

              ),
            ),
            Row(
              children: [
                const Text(
                  'Title:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _title,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: "Enter the chat title",
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.edit, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _description,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: "Enter the chat description",
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.edit, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ElevatedButton(
                  onPressed: () async {
                    String newTitle = _title.text;
                    String newDescription = _description.text;
                    if (newTitle.isNotEmpty || newDescription.isNotEmpty) {
                      if(newDescription.isNotEmpty) await ChatService().editThreadDescription(widget.thread, newDescription);
                      if(newTitle.isNotEmpty) await ChatService().editThreadTitle(widget.thread, newTitle);
                      Thread newThread = Thread(
                          uid: widget.thread.uid,
                          creator: widget.thread.creator,
                          creation: widget.thread.creation,
                          members: widget.thread.members,
                          title: newTitle,
                          description: newDescription,
                          icon: icon
                      );
                      if (context.mounted) {

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const ActiveChatsView()),
                                (Route<dynamic> route) => route.isFirst
                        );
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => ChatView(thread: newThread)),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;
    final file = File(result.files.single.path!);

    final newIcon = await ChatService().editThreadPhoto(widget.thread, file);
    setState(() {
      icon = newIcon;
    });
  }
}
