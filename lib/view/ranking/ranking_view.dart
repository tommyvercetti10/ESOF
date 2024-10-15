import 'package:brainshare/view/utils/profile_image_circular_widget.dart';
import 'package:flutter/material.dart';
import '../../services/auth/auth_user.dart';


class RankingView extends StatefulWidget {
  final Map<AuthUser, double> usersRating;
  final List<AuthUser> orderedUsers;

  const RankingView({super.key, required this.usersRating, required this.orderedUsers});

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.orderedUsers.length,
        itemBuilder: (context, index) {
          AuthUser user = widget.orderedUsers[index];
          double rating = widget.usersRating[user]!;
          return ListTile(
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text('#${index+1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                profileWidget(photoURL: user.photoURL, width: 50, height: 50, size: 50),
              ],
            ),
            title: Text(user.username),
            trailing: Text('$rating/5 ☆',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          );
        },
      ),
    );
  }
}
