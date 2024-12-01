import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TagFriendsPage extends StatefulWidget {
  const TagFriendsPage({Key? key}) : super(key: key);

  @override
  State<TagFriendsPage> createState() => _TagFriendsPageState();
}

class _TagFriendsPageState extends State<TagFriendsPage> {
  String userId = "Y97bByJ64bgN0umSLhbovZauSTR2";

  List<Map<String, dynamic>> friends = []; // Firestore에서 가져오는 친구 목록

  final List<String> selectedFriends = []; // 선택된 친구 목록

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  // 현재 로그인한 사용자의 following 배열에서 친구 UID를 가져오고, 친구 정보를 로드
  Future<void> _loadFriends() async {
    try {
      // 현재 로그인한 사용자의 데이터 가져오기
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      List<dynamic> following = userDoc['following'] ?? [];

      // 친구 UID에 해당하는 정보를 가져오기
      List<Map<String, dynamic>> friendsList = [];
      for (var friendUid in following) {
        DocumentSnapshot friendDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(friendUid)
            .get();
        if (friendDoc.exists) {
          friendsList.add({
            'uid': friendUid,
            'nickname': friendDoc['nickname'],
            'email': friendDoc['email'],
            // 추가적인 친구 정보가 있으면 여기서 가져올 수 있음
          });
        }
      }

      // 상태 업데이트
      setState(() {
        friends = friendsList;
      });
    } catch (e) {
      print('Error loading friends: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 태그'),
        actions: [
          TextButton(
            onPressed: () {
              // 선택된 친구들의 UID와 nickname을 반환
              List<Map<String, String>> selectedFriendDetails = [];
              for (var uid in selectedFriends) {
                var friend =
                    friends.firstWhere((friend) => friend['uid'] == uid);
                selectedFriendDetails.add({
                  'uid': friend['uid'],
                  'nickname': friend['nickname'],
                });
              }
              Navigator.pop(
                  context, selectedFriendDetails); // 선택된 친구의 UID와 nickname을 넘겨줌
            },
            child: const Text(
              '완료',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: friends.isEmpty
          ? const Center(child: CircularProgressIndicator()) // 친구 목록 로딩 중일 때
          : ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                final friendName = friend['nickname'];
                final friendUid = friend['uid'];
                final isSelected =
                    selectedFriends.contains(friendUid); // 선택 여부 확인

                return ListTile(
                  title: Text(friendName),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (!selectedFriends.contains(friendUid)) {
                            selectedFriends.add(friendUid); // 친구 추가
                          }
                        } else {
                          selectedFriends.remove(friendUid); // 친구 제거
                        }
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
