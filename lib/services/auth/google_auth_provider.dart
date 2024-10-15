import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_provider.dart' as auth;
import 'auth_user.dart';

class GAuthProvider extends auth.AuthProvider {
  final _googleSignIn = GoogleSignIn();

  @override
  Future<void> logIn({String? email, String? password}) async {
    await signInWithGoogle();
  }

  @override
  Future<void> createUser({String? username, String? email, String? password}) async {
    try {
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
      var doc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      if(!doc.exists) {
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  @override
  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Future<AuthUser?> getUser(String uuid) async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? AuthUser(uuid: user.uid, username: user.email!, photoURL: '', status: '') : null;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        await createUser(username: _googleSignIn.currentUser?.displayName);
      } else {
        log("Google sign-in was cancelled or failed before authentication.");
      }
    } catch (e) {
      log("Error during Google sign-in: $e");
    }
  }
}