import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/auth_service.dart';
import '../auth/auth_user.dart';
import '../storage/storage_service.dart';


class ProfileUpdateService {
  final User? _user = AuthService.firebase().currentUser;
  final StorageService _storageService = StorageService();

  Future<String> getDocId(String? uuid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("users").get();
    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> aux = docSnapshot.data() as Map<String, dynamic>;
      if (aux["uuid"] == (uuid ?? _user!.uid)) {
        return docSnapshot.id;
      }
    }
    return "";
  }

  Future<void> updateBio(String bio) async {
    String docId = await getDocId(null);
    await FirebaseFirestore.instance.collection("users").doc(docId).update({"bio" : bio});
  }

  Future<void> updatePhotoURL(File image) async {
    String docId = await getDocId(null);
    await _storageService.addFile(image, _user!.uid);
    String photoURL = await _storageService.getURL(_user.uid);
    await FirebaseFirestore.instance.collection("users").doc(docId).update({"photoURL" : photoURL});
    _user.updatePhotoURL(photoURL);
  }

  Future<void> updateCvURL(File file) async {
    String docId = await getDocId(_user?.uid);
    await _storageService.addFile(file, "cv${_user?.uid}") ;
    String cvURL = await _storageService.getURL("cv${_user?.uid}");
    await FirebaseFirestore.instance.collection("users").doc(docId).update({"cvURL" : cvURL});

  }

  Future<void> updateStatus(String status) async {
    String docId = await getDocId(null);
    await FirebaseFirestore.instance.collection("users").doc(docId).update({"status" : status});
  }

  Future<void> banUser(AuthUser user) async {
    String docId = await getDocId(user.uuid);
    await FirebaseFirestore.instance.collection("users").doc(docId).update({"isBanned" : true});
  }

  Future<AuthUser> getProfile() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection("users").doc(await getDocId(null)).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return AuthUser(
        uuid: data["uuid"],
        username: data["username"],
        photoURL: data["photoURL"] ?? "",
        bio: data["bio"],
        status: data["status"] ?? "",
        isBanned: data["isBanned"] ?? false,
        isModerator: data["isModerator"] ?? false,
        cvURL: data["cvURL"] ?? "",
      );
    } else {
      throw Exception('User not found.');
    }
  }

}