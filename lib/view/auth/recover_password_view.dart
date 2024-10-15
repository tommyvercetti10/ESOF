import 'package:brainshare/view/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import '../../services/auth/auth_service.dart';

class RecoverPasswordView extends StatefulWidget {
  const RecoverPasswordView({super.key});

  @override
  State<RecoverPasswordView> createState() => _RecoverPasswordViewState();
}

class _RecoverPasswordViewState extends State<RecoverPasswordView> {

  late TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("A email will be sent with the instructions to reset your password!",
                  style: TextStyle(fontSize: 20)
              ),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(
                    hintText: "Email"
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    try {
                      await AuthService.firebase().sendPasswordResetEmail(email);
                      if(context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                    catch(e) {
                      if(context.mounted) {
                        showErrorDialog(context, "Something went wrong!");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 1, 54, 89),
                      foregroundColor: Colors.white,
                      fixedSize: const Size(150, 40)
                  ),
                  child: const Text("Send Email")
              ),
            ],
          ),
        )
    );
  }
}
