import 'package:brainshare/model/comment.dart';
import 'package:brainshare/services/user_content/comment_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../services/auth/auth_service.dart';


class AddCommentsView extends StatefulWidget {
  final String receiverUid;
  const AddCommentsView({super.key, required this.receiverUid});

  @override
  State<StatefulWidget> createState() => _AddCommentViewState();
}

class _AddCommentViewState extends State<AddCommentsView> {
  final TextEditingController _commentText = TextEditingController();
  User? _user;
  double _rating = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _user = AuthService.firebase().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          )
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(_user?.photoURL ?? ''),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _commentText,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'What are your thoughts?',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 35),
              child: Row(
                children: [
                  RatingBar.builder(
                      initialRating: 0.5,
                      minRating: 0.5,
                      maxRating: 5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      onRatingUpdate: (rating){
                        _rating = rating;

                      }
                  )
                ],
              ),
            ),
            if (_loading) const CircularProgressIndicator(),

          ],
        ),
      ),
      floatingActionButton: _loading ? null : FloatingActionButton(
        onPressed: () async {
          await _addComment();
          if(context.mounted) {
            Navigator.pop(context);
          }
        },
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        child: const Icon(Icons.send),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.white,
    );
  }

  Future<void> _addComment() async {
    if (_commentText.text.isNotEmpty) {
      setState(() {
        _loading = true;
      });
      try {
        String text = _commentText.text;
        Comment comment = Comment(_user!.uid, text, _rating, widget.receiverUid, false);
        await CommentService().addComment(comment);
        _commentText.clear();
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}
