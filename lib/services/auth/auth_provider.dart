import 'package:firebase_auth/firebase_auth.dart';

import 'auth_user.dart';


abstract class AuthProvider {

  Future<void> logIn({String email, String password});

  Future<void> createUser({String username, String email, String password});

  Future<void> logout();
  User? get currentUser;

  Future<AuthUser?> getUser(String uuid);
}