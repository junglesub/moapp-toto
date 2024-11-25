import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:moapp_toto/screens/friend/widgets/find_friend.dart';
import 'package:moapp_toto/screens/friend/widgets/recommand_friend_row.dart';
import 'package:moapp_toto/widgets/custom_full_button.dart';

import 'package:search_page/search_page.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> friends = [
      'Friend 1',
      'Friend 2',
      'Friend 3',
      'Friend 4',
      'Friend 5',
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
            child: RecommandFriendRow(
              friends: friends,
            ),
          ),
        ],
      ),
    );
  }
}
