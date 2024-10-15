import 'package:flutter/material.dart';
import 'package:brainshare/view/home_screen_view.dart';
import 'package:brainshare/view/auth/sign_in_view.dart';
import 'package:brainshare/services/auth/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      AuthService.firebase().init().then((_) {
        final user = AuthService.firebase().currentUser;
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => user != null ? const HomeScreenView() : const SignInView(),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Image.asset("assets/images/logo.png", width: 200, height: 200),
      ),
    );
  }
}
