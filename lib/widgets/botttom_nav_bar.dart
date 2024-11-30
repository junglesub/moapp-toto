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
          icon: Icon(Icons.group),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
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

// import 'package:flutter/material.dart';
// import 'package:bottom_bar_matu/bottom_bar_matu.dart';

// class CustomBottomNavigationBar extends StatelessWidget {
  
//   final int currentIndex;
//   final Function(int) onTap;

//   const CustomBottomNavigationBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomBarBubble(
//       selectedIndex: currentIndex,
//       items: [
//         BottomBarItem(iconData: Icons.home),
//         BottomBarItem(iconData: Icons.local_activity),
//         BottomBarItem(iconData: Icons.group),
//         BottomBarItem(iconData: Icons.notifications),
//         BottomBarItem(iconData: Icons.account_circle),
//       ],
//       onSelect: (index) {
//         switch (index) {
//           case 0:
//             Navigator.pushNamed(context, '/');
//             break;
//           case 1:
//             Navigator.pushNamed(context, '/mission');
//             break;
//           case 2:
//             Navigator.pushNamed(context, '/friend');
//             break;
//           case 3:
//             Navigator.pushNamed(context, '/notification');
//             break;
//           case 4:
//             Navigator.pushNamed(context, '/profile');
//             break;
//         }
//       },
//       color: Colors.black,
//     );
//   }
// }

