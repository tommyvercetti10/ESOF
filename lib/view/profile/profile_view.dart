import 'package:brainshare/services/local_storage/local_database.dart';
import 'package:brainshare/storage/user_cache.dart';
import 'package:flutter/material.dart';
import 'package:brainshare/services/auth/auth_service.dart';
import 'package:brainshare/services/user_content/comment_service.dart';
import 'package:brainshare/view/user_content/comments/add_comments_view.dart';
import 'package:brainshare/view/user_content/comments/comments_list_view.dart';
import 'package:brainshare/view/user_content/posts/posts_list_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../main.dart';
import '../../services/auth/auth_user.dart';
import '../../services/local_storage/user_preferences.dart';
import '../../services/user_content/post_service.dart';
import '../utils/profile_image_circular_widget.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  final String? uuid;
  const ProfileView({super.key, this.uuid});

  @override
  State<StatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final PostService postService;
  late final CommentService commentService;
  late bool isCurrentUser;
  bool showPosts = true;
  bool showComments = false;
  bool isDarkMode = false;
  AuthUser? user;

  @override
  void initState() {
    super.initState();
    postService = PostService();
    commentService = CommentService();
    isCurrentUser = widget.uuid == null;
    refreshUser();
  }

  Future<void> refreshUser() async {
    if (isCurrentUser) {
      String? userId = AuthService.firebase().currentUser?.uid;
      if (userId != null) {
        user = await UserCache.get(userId);
      }
    } else {
      user = await UserCache.get(widget.uuid ?? "");
    }
    setState(() {});
  }

  Future<void> saveUserPreferences() async {
    String? userId = AuthService.firebase().currentUser?.uid;
    if (userId != null) {
      UserPreferences preferences = UserPreferences(uuid: userId, isDarkMode: isDarkMode);
      await LocalDatabase().insertPreference(preferences);
    }
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    MyApp.of(context).setThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    saveUserPreferences();
  }


  @override
  Widget build(BuildContext context) {
    String? uuid = user?.uuid;
    String? username = user?.username;
    String? photoURL = user?.photoURL;
    String? status = user?.status;
    String? bio = user?.bio;

    return Scaffold(
      appBar: isCurrentUser
          ? null
          : AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: toggleTheme,
                icon: const Icon(Icons.sunny),
              )
            ],
          ),
          Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: profileWidget(
                      photoURL: photoURL,
                      width: 120,
                      height: 120,
                      size: 50)),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: IconButton(
                    icon: isCurrentUser
                        ? const Icon(Icons.edit,
                        size: 20, color: Colors.black87)
                        : const Icon(Icons.star,
                        size: 20, color: Colors.amberAccent),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            if (isCurrentUser) {
                              return EditProfileView(authUser: user!);
                            } else {
                              return AddCommentsView(
                                  receiverUid: uuid ?? "");
                            }
                          })).then((_) => refreshUser());
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(username ?? "",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(status ?? "Available",
                  style: const TextStyle(fontSize: 16))),
          Center(
            child: Text(
              bio ?? "No bio",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.0
              ),
            ),
          ),
          if (user?.cvURL != null && user?.cvURL != "")
            TextButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: const Text('CV'),
                        ),
                        body: SfPdfViewer.network(user!.cvURL ?? ""),
                      )));
                },
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.link), Text("Checkout CV")])),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPosts = true;
                      showComments = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text('Posts'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPosts = false;
                      showComments = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text('Comments'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: showPosts
                  ? PostsListWidget(
                  uuid: uuid ?? '', fromUser: true, category: '')
                  : commentsListWidget(uuid ?? '', true),
            ),
          ),
        ],
      ),
    );
  }
}