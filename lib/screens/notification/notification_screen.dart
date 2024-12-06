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
  @override
  Widget build(BuildContext context) {
    NotificationProvider np = context.watch();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('알림'),
      ),
      body: np.n.isEmpty
          ? const Center(
              child: Text(
                '알림이 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
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
                    notification.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('알림이 삭제되었습니다.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.notifications),
                        ),
                        title: Row(
                          children: [
                            Text(notification.title ??
                                notification.id ??
                                "unknown"),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              "${getRelativeTime(notification.created)}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        subtitle: Text('${notification.message}.'),
                        onTap: () {
                          // 알림 클릭 시 동작
                          // print('알림 클릭: ${notification['title']}');
                        },
                      ),
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
      ),
    );
  }
}
