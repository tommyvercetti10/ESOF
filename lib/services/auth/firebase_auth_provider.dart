import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_user.dart';
import 'auth_provider.dart' as auth;

class FirebaseAuthProvider implements auth.AuthProvider {

  @override
  User? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  @override
  Future<void> logIn({String? email, String? password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> createUser({String? username, String? email, String? password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      await FirebaseAuth.instance.currentUser?.updateDisplayName(username!);
      Map<String, dynamic> data = {
        "uuid": FirebaseAuth.instance.currentUser!.uid,
        "username": FirebaseAuth.instance.currentUser!.displayName,
        "photoURL": FirebaseAuth.instance.currentUser!.photoURL,
        "bio": '',
        "status": 'Available',
        "isBanned": false,
        "isModerator": false,
        "cv": '',
      };
      await FirebaseFirestore.instance.collection("users").add(data);
    } catch (e) {
      rethrow ;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthUser?> getUser(String uuid) async {
    Map<String, dynamic> data = {};
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("users").get();
    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> aux = docSnapshot.data() as Map<String, dynamic>;
      if (aux["uuid"] == uuid) {
        data = aux;
        break;
      }
    }
    if (data.isEmpty) {
      return null;
    }
    return AuthUser(
      uuid: uuid,
      username: data["username"],
      photoURL: data["photoURL"] ?? "",
      bio: data["bio"] ?? "",
      status : data["status"] ?? "",
      isBanned: data["isBanned"] ?? false,
      isModerator: data["isModerator"] ?? false,
      cvURL : data["cvURL"] ?? "",
    );
  }
}

