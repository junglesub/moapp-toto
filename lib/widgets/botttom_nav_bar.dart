import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_activity),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: '',
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
