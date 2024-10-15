import 'dart:io';
import 'package:brainshare/model/thread.dart';
import 'package:brainshare/services/auth/auth_user.dart';
import 'package:brainshare/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ChatService>(), MockSpec<DocumentReference>(), MockSpec<QuerySnapshot>(), MockSpec<DocumentSnapshot>(), MockSpec<File>(), MockSpec<Thread>(), MockSpec<AuthUser>()])

void main() {
  late MockChatService chatService;
  late MockDocumentReference mockDoc;
  late MockQuerySnapshot querySnapshot;
  late MockDocumentSnapshot docSnapshot;
  late MockThread thread;
  late MockAuthUser user;

  setUp(() {
    chatService = MockChatService();
    mockDoc = MockDocumentReference();
    querySnapshot = MockQuerySnapshot();
    docSnapshot = MockDocumentSnapshot();
    thread = MockThread();
    user = MockAuthUser();
  });

  group("Chat Service tests", () {
    test("Get Messages test", () {
      when(chatService.getMessages(mockDoc)).thenAnswer((_) => Stream.value(querySnapshot as QuerySnapshot));

      expect(chatService.getMessages(mockDoc), isA<Stream<QuerySnapshot>>());

      verify(chatService.getMessages(mockDoc)).called(1);
    });

    test("Get User Messages test", () {
      when(chatService.getChats("uuid")).thenAnswer((_) => Stream.value(querySnapshot as QuerySnapshot));

      expect(chatService.getChats("uuid"), isA<Stream<QuerySnapshot>>());

      verify(chatService.getChats("uuid")).called(1);
    });

    test("Send Message test", () async {
      File file = File("file");
      when(chatService.sendMessage(mockDoc, "uuid", file, null)).thenAnswer((_) async => Future.value());

      await chatService.sendMessage(mockDoc, "uuid", file, null);

      verify(chatService.sendMessage(mockDoc, "uuid", file, null)).called(1);
    });

    test("Delete Message", () async {
      when(chatService.deleteMessage(docSnapshot)).thenAnswer((_) async => Future.value());

      await chatService.deleteMessage(docSnapshot);

      verify(chatService.deleteMessage(docSnapshot)).called(1);
    });

    test("Edit Message", () async {
      when(chatService.editMessageText(docSnapshot, "mock test")).thenAnswer((_) async => Future.value());

      await chatService.editMessageText(docSnapshot, "mock test");

      verify(chatService.editMessageText(docSnapshot, "mock test")).called(1);
    });
  });

  test("Like Message", () async {
    when(chatService.likeMessage(docSnapshot, user)).thenAnswer((_) async => Future.value());

    await chatService.likeMessage(docSnapshot, user);

    verify(chatService.likeMessage(docSnapshot, user)).called(1);
  });

  test("Edit Thread Title", () async {
    when(chatService.editThreadTitle(thread, "title")).thenAnswer((_) async => Future.value());

    await chatService.editThreadTitle(thread, "title");

    verify(chatService.editThreadTitle(thread, "title")).called(1);
  });

  test("Edit Thread Description", () async {
    when(chatService.editThreadDescription(thread, "description")).thenAnswer((_) async => Future.value());

    await chatService.editThreadDescription(thread, "description");

    verify(chatService.editThreadDescription(thread, "description")).called(1);
  });

  test("Edit Thread Photo", () async {
    File file = File("file");
    when(chatService.editThreadPhoto(thread, file)).thenAnswer((_) async => "");

    await chatService.editThreadPhoto(thread, file);

    verify(chatService.editThreadPhoto(thread, file)).called(1);
  });
}
