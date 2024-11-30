import 'package:flutter/material.dart';
import 'package:moapp_toto/models/user_entity.dart';
import 'package:moapp_toto/provider/all_users_provider.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:moapp_toto/screens/friend/widgets/current_friend_list.dart';
import 'package:moapp_toto/screens/friend/widgets/find_friend.dart';
import 'package:moapp_toto/screens/friend/widgets/recommand_friend_row.dart';
import 'package:moapp_toto/screens/signUp/signUp_screen.dart';
import 'package:moapp_toto/widgets/botttom_nav_bar.dart';
import 'package:provider/provider.dart';

int _selectedIndex = 2;

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    AllUsersProvider aup = context.watch();
    UserProvider up = context.watch();
    print(aup.au);
    final List<UserEntry?> recommendFriend = aup.au
        .where((user) =>
            (user?.following.contains(up.currentUser?.uid) ?? false) &&
            (up.ue?.following.contains(user?.uid) == false))
        .toList();

    final List<UserEntry?> currentFriends = up.ue?.following.map((uid) {
          final user = aup.au.firstWhere((u) => uid == u?.uid);

          return user;
        }).toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 검색하기'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FindFriend(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '회원님을 위한 친구 추천',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 2,
            child: RecommandFriendRow(
              friends: recommendFriend,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              '현재 친구',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          CurrentFriendList(currentFriends: currentFriends),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
