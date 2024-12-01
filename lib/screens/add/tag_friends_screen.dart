import 'package:flutter/material.dart';

class TagFriendsPage extends StatefulWidget {
  const TagFriendsPage({Key? key}) : super(key: key);

  @override
  State<TagFriendsPage> createState() => _TagFriendsPageState();
}

class _TagFriendsPageState extends State<TagFriendsPage> {
  // 예시 데이터
  final List<String> friends = [
    'Alice',
    'Bob',
    'Charlie',
    'Diana',
    'Eve',
    'Frank',
  ];

  // 선택된 친구 목록
  final List<String> selectedFriends = []; // Set에서 List로 변경

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 태그'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedFriends); // 선택된 친구 반환
            },
            child: const Text(
              '완료',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          final isSelected = selectedFriends.contains(friend); // 선택 여부 확인

          return ListTile(
            title: Text(friend),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    if (!selectedFriends.contains(friend)) {
                      selectedFriends.add(friend); // 친구 추가
                    }
                  } else {
                    selectedFriends.remove(friend); // 친구 제거
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
