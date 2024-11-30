import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int notificationCount;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      currentIndex: currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/mission');
            break;
          case 2:
            Navigator.pushNamed(context, '/friend');
            break;
          case 3:
            Navigator.pushNamed(context, '/notification');
            break;
          case 4:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.local_activity),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: badges.Badge(
            badgeContent: Text(
              notificationCount > 0 ? '$notificationCount' : '',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.all(6),
            ),
            child: const Icon(Icons.notifications),
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: '',
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
