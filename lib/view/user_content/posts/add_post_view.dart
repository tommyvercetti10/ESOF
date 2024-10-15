import 'package:brainshare/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/user_content/post_service.dart';

class AddPostView extends StatefulWidget {
  const AddPostView({super.key});

  @override
  State<StatefulWidget> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  final TextEditingController _postText = TextEditingController();
  final List<String> dropDownEntries = ["Maths", "Biology", "Science", "Computer Science", "Arts"];
  String? category;
  User? user;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    user = AuthService.firebase().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user?.photoURL ?? ''),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _postText,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                    decoration: InputDecoration(
                      hintText: 'What are you looking for?',
                      hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey[200],
                ),
                value: category,
                icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.blueGrey),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                onChanged: (String? newValue) {
                  setState(() {
                    category = newValue;
                  });
                },
                items: dropDownEntries.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            if (_loading) const CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: _loading ? null : FloatingActionButton(
        onPressed: _addPost,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        child: const Icon(Icons.send),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Future<void> _addPost() async {
    if (_postText.text.isNotEmpty && category != null) {
      setState(() {
        _loading = true;
      });
      try {
        String text = _postText.text;
        Post post = Post(user!.uid, text, category!);
        await PostService().addPost(post);
        _postText.clear();
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}
