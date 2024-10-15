

import 'dart:developer';

import 'package:brainshare/services/profile/profile_update_service.dart';
import 'package:flutter/material.dart';
import '../../../model/post.dart';
import '../../../services/auth/auth_user.dart';
import '../../../services/user_content/post_service.dart';

Future<void> showPostDialog(BuildContext context, Post post, AuthUser currentUser, AuthUser user, VoidCallback onPostDeleted) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Text('Options'),
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user.uuid == currentUser.uuid) ListTile(
              title: const Text('Delete Post'),
              onTap: () async {
                await PostService().deletePost(post);
                if (context.mounted) {
                  Navigator.pop(context);
                  onPostDeleted();
                }
              },
            ),
            if (user.uuid != currentUser.uuid && (currentUser.isModerator ?? false) && !(user.isModerator ?? false)) ListTile(
              title: const Text('Ban User'),
              onTap: () async {
                log(user.username);
                log(currentUser.username);
                await ProfileUpdateService().banUser(user);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
