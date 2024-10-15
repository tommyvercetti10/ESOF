import 'package:flutter/material.dart';
import '../../../model/comment.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/auth/auth_user.dart';
import '../../../model/utils/date_utils.dart' as date;

class CommentView extends StatefulWidget {

  final Comment comment;

  const CommentView({
    super.key,
    required this.comment,
  });

  
  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  bool isLoading = true;
  AuthUser? user;

  @override
  void initState() {
    super.initState();
    getUser().then((value) => setState(() {
      isLoading = false;
    }));
  }

  Future<void> getUser() async {
    user = await AuthService.firebase().getUser(widget.comment.author);
  }

  @override
  Widget build(BuildContext context) {
    String timeSince = date.DateUtils.getDeltaTime(widget.comment.timestamp);
    ThemeData themeData = Theme.of(context);

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
      color: themeData.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user?.photoURL ?? ''),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Text(
                user?.username ?? '',
                style: themeData.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                timeSince,
                style: themeData.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            widget.comment.text,
            style: themeData.textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          if(widget.comment.rating>0)
            Text(
              ' ${widget.comment.rating.toStringAsFixed(1)}/5 ☆',
              style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

