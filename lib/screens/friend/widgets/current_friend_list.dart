import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moapp_toto/models/notification_entity.dart';
import 'package:moapp_toto/models/user_entity.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:moapp_toto/screens/friend/widgets/find_friend.dart';
import 'package:provider/provider.dart';

class CurrentFriendList extends StatelessWidget {
  const CurrentFriendList({
    super.key,
    required this.currentFriends,
  });

  final List<UserEntry?> currentFriends;

  @override
  Widget build(BuildContext context) {
    UserProvider up = context.watch();
    return Expanded(
      flex: 3,
      child: ListView.builder(
        itemCount: currentFriends.length,
        itemBuilder: (context, index) {
          final friend = currentFriends[index];
          if (friend == null) return Container();
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Slidable(
              key: ValueKey(friend),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${friend.nickname}님을 찔렀습니다.')),
                      );
                      NotificationEntity(
                              id: null,
                              code: "poke",
                              from: up.ue,
                              to: friend,
                              title: "찌르기 알림",
                              message: "${up.ue?.nickname}님이 당신을 찔렀습니다")
                          .save();
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.message,
                    label: '찌르기',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      up.ue?.removeFollowing(friend.uid);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('${friend.nickname ?? friend.uid} 언팔로우')),
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: '언팔로우',
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    (friend.nickname ?? friend.email ?? friend.uid)[0],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                title: Text(friend.nickname ?? ""),
                subtitle: Text(friend.email ?? ""),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Viewing $friend\'s profile')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
