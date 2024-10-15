import 'package:brainshare/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../model/message.dart';
import '../../../services/auth/auth_user.dart';


Future<void> showMessageDialog(BuildContext context, DocumentSnapshot doc, AuthUser currentUser) async {
  Message message = Message.fromJSON(doc);
  TextEditingController controller = TextEditingController(text: message.text);
  bool isEditing = false;

  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text("Options"),
                content: isEditing
                    ? TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Edit your message here...',
                    border: OutlineInputBorder(),
                  ),
                )
                    : null,
                actions: isEditing
                    ? [
                  TextButton(
                      onPressed: () async {
                        if(controller.text.isNotEmpty) {
                          await ChatService().editMessageText(doc, controller.text);
                        }
                        if(context.mounted) {
                          Navigator.of(context).pop();  // Close the dialog
                        }
                      },
                      child: const Text("Save")
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() => isEditing = false);
                      },
                      child: const Text("Cancel")
                  ),
                ]
                    : [
                  TextButton(
                      onPressed: () async {
                        await ChatService().likeMessage(doc, currentUser);
                        if(context.mounted) {
                          Navigator.of(context).pop();  // Close the dialog
                        }
                      },
                      child: const Text("Like Message")
                  ),
                  if(currentUser.isModerator ?? false) TextButton(
                      onPressed: () async {
                        await ChatService().deleteMessage(doc);
                        if(context.mounted) {
                          Navigator.of(context).pop();  // Close the dialog
                        }
                      },
                      child: const Text("Delete Message")
                  ),
                  if(currentUser.isModerator ?? false) TextButton(
                      onPressed: () {
                        setState(() => isEditing = true);
                      },
                      child: const Text("Edit Message")
                  ),
                ],
              );
            }
        );
      }
  );
}