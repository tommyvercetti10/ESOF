import 'package:brainshare/services/auth/auth_service.dart';
import 'package:brainshare/services/user_content/post_service.dart';
import 'package:brainshare/view/ranking/ranking_view.dart';
import 'package:brainshare/view/user_content/posts/posts_list_view.dart';
import 'package:brainshare/view/utils/podium_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/post.dart';
import '../services/auth/auth_user.dart';
import '../services/user_content/comment_service.dart';


class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final PostService postService = PostService();
  final currentUser = AuthService.firebase().currentUser;
  late Future<List<Post>> postsFuture;
  List<String> categories = ["All", "Maths", "Biology", "Arts", "Science", "Computer Science"];
  String selectedCategory = "";
  Map<AuthUser, double> usersRating = {};
  List<AuthUser> orderedUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setupRanking().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    postService.dispose();
  }

  Future<void> setupRanking() async {
    QuerySnapshot aux = await FirebaseFirestore.instance.collection("users").get();
    Map<AuthUser, double> newUsersRating = {};
    List<AuthUser> newOrderedUsers = [];

    for (DocumentSnapshot doc in aux.docs) {
      Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
      AuthUser user = AuthUser.fromJSON(json);
      double rating = await CommentService().getAverageForUser(user.uuid);
      newUsersRating[user] = rating;
      newOrderedUsers.add(user);
    }

    newOrderedUsers.sort((a, b) => newUsersRating[b]!.compareTo(newUsersRating[a]!));

    setState(() {
      usersRating = newUsersRating;
      orderedUsers = newOrderedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PodiumWidget(ranking: orderedUsers),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RankingView(orderedUsers: orderedUsers, usersRating: usersRating)));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Check Rank", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                return Container(
                  width: 100,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        if (category == 'All') {
                          selectedCategory = '';
                        } else {
                          selectedCategory = category;
                        }
                      });
                    },
                    child: Text(category),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: PostsListWidget(
              uuid: currentUser!.uid,
              fromUser: false,
              category: selectedCategory,
            ),
          ),
        ],
      ),
    );
  }
}



