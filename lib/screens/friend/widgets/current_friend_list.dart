import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CurrentFriendList extends StatelessWidget {
  const CurrentFriendList({
    super.key,
    required this.currentFriends,
  });

  final List<String> currentFriends;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: ListView.builder(
        itemCount: currentFriends.length,
        itemBuilder: (context, index) {
          final friend = currentFriends[index];
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
                      // Handle message action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Messaging $friend')),
                      );
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.message,
                    label: '찌르기',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      // Handle unfriend action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$friend unfriended')),
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Unfriend',
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    friend[0],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                title: Text(friend),
                subtitle: const Text('Tap to view profile'),
                onTap: () {
                  // Navigate to friend's profile or perform another action
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
