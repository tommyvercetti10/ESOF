import 'dart:io';

import 'package:brainshare/model/chat.dart';
import 'package:brainshare/services/auth/auth_service.dart';
import 'package:brainshare/services/storage/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../../model/message.dart';
import '../../model/post.dart';
import '../../model/thread.dart';
import '../auth/auth_user.dart';

class ChatService extends ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get chats a user is in (includes Threads)
  Stream<QuerySnapshot> getChats(String userId) {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .snapshots();
  }

  /// Get messages from a conversation
  Stream<QuerySnapshot> getMessages(DocumentReference ref) {
    return ref
        .collection('messages')
        .orderBy('at', descending: false)
        .snapshots();
  }

  /// Create chat with another user
  Future<Chat> createChat(AuthUser user2) async {

    String? userId = AuthService.firebase().currentUser?.uid;
    if (userId == null) {
      throw Exception("Invalid state to send message: null user");
    }

    Chat chat = Chat (
        uid: const Uuid().v4(),
        creation: Timestamp.now(),
        creator: userId,
        partner: user2
    );

    await _firestore
        .collection('chats')
        .doc(chat.uid)
        .set(chat.toJSON());

    return chat;
  }

  /// Create a thread between a group of users
  Future<Thread> createThread(String title, String? desc, List<AuthUser> members) async {

    String? userId = AuthService.firebase().currentUser?.uid;
    if (userId == null) {
      throw Exception("Invalid state to send message: null user");
    }

    Thread thread = Thread (
      uid: const Uuid().v4(),
      creation: Timestamp.now(),
      creator: userId,
      members: members,
      admins: [userId],
      description: desc,
      title: title,
    );

    await _firestore
        .collection('chats')
        .doc(thread.uid)
        .set(thread.toJSON());

    return thread;
  }

  /// Send a message to a chat or a thread
  Future<void> sendMessage(DocumentReference ref, String? text, File? file, Post? post) async {

    User? user = AuthService.firebase().currentUser;
    if (user == null) {
      throw Exception("Invalid state to send message: null user");
    }

    final String sender = user.uid;
    final Timestamp at = Timestamp.now();
    Message message;
    if(post == null) {
      late String? url = "";

      if (file != null) {
        // storage file
        String fileUid = const Uuid().v4();
        await StorageService().addFile(file, fileUid);
        url = await StorageService().getURL(fileUid);
      }

      message = Message (
          uid: const Uuid().v4(),
          sender: sender,
          text: text ?? "",
          file: url,
          at: at,
          likes: []
      );
    }
    else {
      message = Message (
          uid: const Uuid().v4(),
          sender: sender,
          text: text ?? "",
          file: null,
          postId: post.id,
          at: at,
          likes: []
      );
    }

    await ref
        .collection('messages')
        .add(message.toJSON());
  }




  Future<String> editThreadPhoto(Thread thread, File image) async {
    String fileUid = const Uuid().v4();
    await StorageService().addFile(image, fileUid);
    String url = await StorageService().getURL(fileUid);

    await _firestore.collection('chats').doc(thread.uid).update({'icon': url});

    return url;
  }

  Future<void> editThreadTitle(Thread thread, String title) async {
    await _firestore.collection('chats').doc(thread.uid).update({'title': title});
  }

  Future<void> editThreadDescription(Thread thread, String description) async {
    await _firestore.collection('chats').doc(thread.uid).update({'description': description});
  }

  Future<void> editMessageText(DocumentSnapshot doc, String newText) async {
    await doc.reference.update({"text" : newText});
  }

  Future<void> deleteMessage(DocumentSnapshot doc) async {
    await doc.reference.delete();
  }

  Future<void> likeMessage(DocumentSnapshot doc, AuthUser currentUser) async {
    Message message = Message.fromJSON(doc);
    if(!message.likes!.contains(currentUser.uuid)) {
      message.likes?.add(currentUser.uuid);
      await doc.reference.update({'likes' : message.likes});
    }
  }
}
