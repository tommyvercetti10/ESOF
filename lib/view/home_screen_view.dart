import 'package:brainshare/view/feed_view.dart';
import 'package:brainshare/view/search/search_view.dart';
import 'package:brainshare/view/user_content/posts/add_post_view.dart';
import 'package:brainshare/view/chat_list/active_chats.dart';
import 'package:brainshare/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../services/auth/auth_service.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BrainShare'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await AuthService.firebase().logout();
            if (context.mounted) {
              Navigator.of(context).popAndPushNamed('/signIn');
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FeedView(),
          SearchView(),
          AddPostView(),
          ActiveChatsView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          _tabController.animateTo(index);
        },
        color: theme.bottomAppBarColor,
        buttonBackgroundColor: theme.colorScheme.secondary,
        animationCurve: Curves.linearToEaseOut,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
