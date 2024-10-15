import 'package:brainshare/view/splash_screen_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'routes.dart';
import 'package:brainshare/services/local_storage/local_database.dart';
import 'package:brainshare/services/local_storage/user_preferences.dart';
import 'package:brainshare/view/auth/recover_password_view.dart';
import 'package:brainshare/view/auth/sign_in_view.dart';
import 'package:brainshare/view/auth/sign_up_view.dart';
import 'package:brainshare/view/user_content/posts/add_post_view.dart';
import 'package:brainshare/view/profile/profile_view.dart';
import 'package:brainshare/view/chat_list/chat_userlist.dart';
import 'package:brainshare/view/home_screen_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<UserPreferences?> _preferencesFuture;
  late LocalDatabase _localDatabase;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _localDatabase = LocalDatabase();
    final userUUID = FirebaseAuth.instance.currentUser?.uid;
    if (userUUID != null) {
      _preferencesFuture = _localDatabase.getPreference(userUUID);
      _preferencesFuture.then((preferences) {
        setState(() {
          _themeMode = preferences?.isDarkMode == true ? ThemeMode.dark : ThemeMode.light;
        });
      });
    } else {
      _preferencesFuture = Future.value(null);
    }
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BrainShare",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
      routes: {
        homeRoute: (context) => const HomeScreenView(),
        signInRoute: (context) => const SignInView(),
        signUpRoute: (context) => const SignUpView(),
        recoverPasswordRoute: (context) => const RecoverPasswordView(),
        chatsRoute: (context) => const ChatsView(),
        profileRoute: (context) => const ProfileView(),
        addPostRoute: (context) => const AddPostView(),
      },
    );
  }
}
