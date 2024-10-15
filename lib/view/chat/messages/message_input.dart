import 'dart:io';

import 'package:brainshare/services/chat/chat_service.dart';
import 'package:brainshare/view/utils/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

Widget messageInputWidget(String chatRoomId, BuildContext context) {
  TextEditingController textController = TextEditingController();
  File? file;
  bool isImageSelected = false;
  bool isFileSelected = false;

  Future<void> selectImage(bool isImage) async {
    final result = await FilePicker.platform.pickFiles(type: isImage ? FileType.image : FileType.any);
    if (result == null) return;
    file = File(result.files.first.path ?? "");
    OpenFile.open(file?.path);
    isImageSelected = isImage;
    isFileSelected = !isImage;
  }
  return Container(
    height: 70,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
    ),
    child: Row(
      children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 25),
                child: TextField(
                  controller: textController,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: false,
                  autocorrect: true,
                )
            )
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      selectImage(true);
                    },
                    icon: const Icon(Icons.image)
                ),
                IconButton(
                    onPressed: () {
                      selectImage(false);
                    },
                    icon: const Icon(Icons.file_present)
                ),
                IconButton(
                    onPressed: () async {
                      final String text = textController.text;
                      if(text.isNotEmpty || isImageSelected || isFileSelected) {
                        await ChatService().sendMessage(FirebaseFirestore.instance.collection("chats").doc(chatRoomId), text, file, null);
                        textController.clear();
                        isImageSelected = false;
                        isFileSelected = false;
                      }
                      else {
                        if(context.mounted) {
                          showErrorDialog(context, "Message cannot be empty.");
                        }
                      }
                    },
                    icon: const Icon(Icons.send_rounded)
                )
              ],
            )
        )
      ],
    ),
  );
}