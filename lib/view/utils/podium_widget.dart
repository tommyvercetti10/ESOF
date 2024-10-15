import 'package:flutter/material.dart';
import '../../services/auth/auth_user.dart';

class PodiumWidget extends StatelessWidget {
  final List<AuthUser> ranking;
  const PodiumWidget({super.key, required this.ranking});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 5),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(ranking[1].photoURL),
                  ),
                ),
              ),
              const Text('#2🥈', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child:
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amberAccent, width: 5),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.amberAccent,
                    backgroundImage: NetworkImage(ranking[0].photoURL),
                  ),
                ),
              ),
              const Text('#1🥇', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 55),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.brown, width: 5),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.brown,
                    backgroundImage: NetworkImage(ranking[2].photoURL),
                  ),
                ),
              ),
              const Text('#3🥉', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}