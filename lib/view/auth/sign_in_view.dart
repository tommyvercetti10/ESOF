import 'package:brainshare/services/auth/auth_exceptions.dart';
import 'package:brainshare/view/utils/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../services/auth/auth_service.dart';


class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          children: [
            Image.asset("assets/images/logo.png", width: 150, height: 150),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.mail),
                          hintText: "Email"
                      ),
                    ),
                    TextField(
                      controller: _password,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      obscureText: true,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: "Password"
                      ),
                    ),
                  ],
                )
            ),
            ElevatedButton(
                onPressed: () async => _handleEmailPasswordSignIn(),
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 40)
                ),
                child: const Text("Login")
            ),
            Center(
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () async => _handleGoogleSignIn(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset("assets/images/google.webp", width: 50, height: 50),
                            const Text("Sign In with Google")
                          ],
                        )
                    ),
                    TextButton(
                        onPressed: () {
                          if (context.mounted) {
                            Navigator.of(context).pushNamed(recoverPasswordRoute);
                          }
                        },
                        child: const Text("Forgot password ?")
                    ),
                  ],
                )
            ),
            const Spacer(),
            Center(
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account ? "),
                    TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(signUpRoute, (route) => false);
                          }
                        },
                        child: const Text("Create an account")
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEmailPasswordSignIn() async {
    final email = _email.text.trim();
    final password = _password.text.trim();
    try {
      await AuthService.firebase().logIn(email: email, password: password);
      if (AuthService.firebase().currentUser != null) {
        _navigateAfterSuccess();
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        await showErrorDialog(context, e.getSignInMessage());
      }
    } catch (e) {
      if (context.mounted) {
        await showErrorDialog(context, "An unexpected error occurred: ${e.toString()}");
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await AuthService.google().logIn();
      if (AuthService.google().currentUser != null) {
        _navigateAfterSuccess();
      } else {
        if (context.mounted) {
          await showErrorDialog(context, "No user account is associated with the sign-in attempt.");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        await showErrorDialog(context, e.getSignInMessage());
      }
    } catch (e) {
      if (context.mounted) {
        await showErrorDialog(context, "An unexpected error occurred: ${e.toString()}");
      }
    }
  }

  void _navigateAfterSuccess() {
    Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
  }
}
