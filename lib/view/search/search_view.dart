import 'package:brainshare/services/auth/auth_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../profile/profile_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<AuthUser> _searchResults = [];
  List<AuthUser> _allUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  Future<void> _fetchAllUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").get();
    List<DocumentSnapshot> docs = snapshot.docs;
    List<AuthUser> users = docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return AuthUser.fromJSON(data);
    }).toList();

    setState(() {
      _allUsers = users;
    });
  }

  void _searchUsers(String query) {
    setState(() {
      _searchResults = _allUsers
          .where((user) => user.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search for users...',
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
          onChanged: _searchUsers,
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Text('No users found'))
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          AuthUser user = _searchResults[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL),
            ),
            title: Text(user.username),
            subtitle: Text(user.status),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfileView(uuid: user.uuid)),
              );
            },
          );
        },
      ),
    );
  }
}

