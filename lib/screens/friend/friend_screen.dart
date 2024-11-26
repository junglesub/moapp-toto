import 'package:flutter/material.dart';
import 'package:moapp_toto/screens/friend/widgets/current_friend_list.dart';
import 'package:moapp_toto/screens/friend/widgets/find_friend.dart';
import 'package:moapp_toto/screens/friend/widgets/recommand_friend_row.dart';
import 'package:moapp_toto/widgets/botttom_nav_bar.dart';

int _selectedIndex = 0;

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    final List<String> friends = [
      'Friend 1',
      'Friend 2',
      'Friend 3',
      'Friend 4',
      'Friend 5',
    ];

    final List<String> currentFriends = [
      'Alice',
      'Bob',
      'Charlie',
      'Diana',
      'Eva',
    ];

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
              friends: friends,
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
