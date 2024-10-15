import 'package:brainshare/services/auth/auth_exceptions.dart';
import 'package:brainshare/view/utils/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../services/auth/auth_service.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  late TextEditingController _username;
  late TextEditingController _email;
  late TextEditingController _password;
  bool termsAndConditions = false;

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          children: [
            Image.asset("assets/images/logo.png", width: 150, height: 150),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _username,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: "Username"
                    ),
                  ),
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
              ),

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: termsAndConditions,
                    onChanged: (bool? value) {
                      setState(() {
                        termsAndConditions = value!;
                      });}
                ),
                const Text("I have read and agreed to the ",
                    style: TextStyle(fontSize: 10)
                ),
                TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => {
                      if(context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            homeRoute, // todo, replace for terms and conditions page
                                (route) => false
                        )}
                    },
                    child: const Text("terms and conditions",
                        style: TextStyle(fontSize: 10),
                        softWrap: true
                    )
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: ElevatedButton(
                  onPressed: () async {
                    final username = _username.text;
                    final email = _email.text;
                    final password = _password.text;

                    if (!termsAndConditions) {
                      if (context.mounted) {
                        await showErrorDialog(context, "You must agree with the terms and conditions to continue!");
                      }
                      return;
                    }
                    try {
                      await AuthService.firebase().createUser(
                          username: username,
                          email: email,
                          password: password
                      );
                      if (context.mounted && AuthService.firebase().currentUser != null) {
                        Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
                      }
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        await showErrorDialog(context, e.getSignUpMessage());
                      }
                    } catch (e) {
                      if (context.mounted) {
                        await showErrorDialog(context, "An unexpected error occurred: ${e.toString()}");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 1, 54, 89),
                      foregroundColor: Colors.white,
                      fixedSize: const Size(150, 40)
                  ),
                  child: const Text("Sign Up")
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    if(context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          signInRoute,
                              (route) => false);
                    }
                  },
                  style: TextButton.styleFrom(alignment: Alignment.center),
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),

      ),


    );
  }
}
