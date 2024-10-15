import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseAuthExceptionSignUpExtension on FirebaseAuthException {
  String getSignUpMessage() {
    switch(code) {
      case "email-already-in-use":
        return "Email already in use";
      case "invalid-email":
        return "Invalid Email";
      case "weak-password":
        return "Choose a better password";
      default:
        return "Something went wrong!";
    }
  }
}


extension FirebaseAuthExceptionSignInExtension on FirebaseAuthException {
  String getSignInMessage() {
    switch(code) {
      case "wrong-password":
        return "Wrong Password";
      case "invalid-email":
        return "Invalid Email";
      case "user-disabled":
        return "The user is disabled";
      case "user-not-found":
        return "The user was not found";
      default:
        return "Something went wrong!";
    }
  }
}