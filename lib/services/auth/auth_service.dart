import 'package:brainshare/services/auth/google_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_user.dart';
import 'auth_provider.dart' as auth;
import 'firebase_auth_provider.dart';

class AuthService implements auth.AuthProvider {
  final auth.AuthProvider provider;
  static final FirebaseAuthProvider _firebaseAuthProvider = FirebaseAuthProvider();
  static final GAuthProvider _googleAuthProvider = GAuthProvider();

  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(_firebaseAuthProvider);

  factory AuthService.google() => AuthService(_googleAuthProvider);

  Future<void> init() async {return;}

  @override
  Future<void> createUser({
    String? username,
    String? email,
    String? password
  }) async {
    await provider.createUser(
        username: username!,
        email: email!,
        password: password!);
  }

  @override
  User? get currentUser => provider.currentUser;

  @override
  Future<void> logIn({
    String? username,
    String? email,
    String? password
  }) async {
    try{
      await provider.logIn(
          email: email ?? "",
          password: password ?? "");
    }
    catch(e) {
      rethrow;
    }

  }

  @override
  Future<void> logout() async {
    return await provider.logout();
  }
  @override
  Future<AuthUser?> getUser(String uuid) async{
    return await provider.getUser(uuid);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}