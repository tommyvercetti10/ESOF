import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../model/post.dart';
import '../auth/auth_user.dart';

class PostService with ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<Post> posts = [];

  Future<List<Post>> getItems() async{
    await fetchPosts();
    return posts;
  }

  Future<void> fetchPosts() async {
    try {
      posts = [];
      QuerySnapshot querySnapshot = await db.collection('posts').orderBy('timestamp', descending: true).get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        posts.add(Post.fromJSON(data, docSnapshot.id));
      }

    } catch (e) {
      log('Error getting documents: $e');
    }
  }

  Future<void> fetchPostsById(String id) async {
    try {
      posts = [];
      DocumentSnapshot docSnapshot = await db.collection('posts').doc(id).get();
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      posts.add(Post.fromJSON(data, docSnapshot.id));
      return;
    } catch (e) {
      log('Error getting documents: $e');
    }
  }

  Future<void> fetchPostsFrom(String uuid) async {
    try {
      posts = [];
      QuerySnapshot querySnapshot = await db.collection('posts').orderBy('timestamp', descending: true).get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        if(data["author"] as String == uuid) posts.add(Post.fromJSON(data, docSnapshot.id));
      }

    } catch (e) {
      log('Error getting documents: $e');
    }
  }

  Future<void> fetchPostsByCategory(String category) async {
    try {
      posts = [];
      QuerySnapshot querySnapshot = await db.collection('posts').orderBy('timestamp', descending: true).get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        if(data["category"] != null && data["category"] as String == category) posts.add(Post.fromJSON(data, docSnapshot.id));
      }

    } catch (e) {
      log('Error getting documents: $e');
    }
  }

  Future<void> addPost(Post post) async {
    try {
      await db.collection('posts').add(post.toJSON());
    } catch(e) {
      log('Error adding post, $e');
    }
  }

  Future<void> deletePost(Post post) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(post.id).delete();
    } catch (e) {
      log('Error deleting post: $e');
    }
  }

  Future<void> likePost(Post post, AuthUser currentUser) async {
    try {
      post.likes.add(currentUser.uuid);
      await FirebaseFirestore.instance.collection("posts").doc(post.id).update({"likes" : post.likes});
    } catch (e) {
      log('Error liking post: $e');
    }
  }

  Future<void> dislikePost(Post post, AuthUser currentUser) async {
    try {
      post.likes.remove(currentUser.uuid);
      await FirebaseFirestore.instance.collection("posts").doc(post.id).update({"likes" : post.likes});
    } catch (e) {
      log('Error liking post: $e');
    }
  }
}