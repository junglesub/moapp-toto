import 'package:flutter/material.dart';
import 'package:moapp_toto/models/notification_entity.dart';
import 'package:moapp_toto/provider/notification_provider.dart';
import 'package:moapp_toto/screens/profile/profile_screen.dart';
import 'package:moapp_toto/utils/date_format.dart';
import 'package:moapp_toto/widgets/botttom_nav_bar.dart';
import 'package:provider/provider.dart';

int _currentIndex = 3;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // final List<Map<String, String>> notifications = [
  //   {'title': '찌르기 알림', 'subtitle': '코딩의 정석씨가 당신을 찔렀습니다', 'timestamp': '5분 전'},
  //   {
  //     'title': '새로운 팔로워가 있습니다.',
  //     'subtitle': '김씨가 당신을 팔로우 합니다.',
  //     'timestamp': '1시간 전'
  //   },
  //   {'title': '미션 성공!', 'subtitle': '투투 티켓을 수령했습니다.', 'timestamp': '어제'},
  // ];

  @override
  Widget build(BuildContext context) {
    NotificationProvider np = context.watch();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('알림'),
      ),
      body: ListView.builder(
        itemCount: np.n.length,
        itemBuilder: (context, index) {
          final notification = np.n[index];
          return Dismissible(
            key: ValueKey(notification.id),
            direction: DismissDirection.horizontal,
            background: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            onDismissed: (direction) {
              // setState(() {
              // notifications.removeAt(index);
              // });
              notification.delete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('알림이 삭제되었습니다.'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.notifications),
                ),
                title: Text(notification.title ?? notification.id ?? "unknown"),
                subtitle: Text(
                    '${notification.message} • ${getRelativeTime(notification.created)}'),
                onTap: () {
                  // 알림 클릭 시 동작
                  // print('알림 클릭: ${notification['title']}');
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          print("Selected tab: $index");
        },
        // notificationCount: notifications.length, // 알림 갯수 전달
      ),
    );
  }
}
