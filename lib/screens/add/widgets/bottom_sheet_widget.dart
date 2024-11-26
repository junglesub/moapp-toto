// import 'package:flutter/material.dart';

// class CustomBottomSheet extends StatelessWidget {
//   final Function() onMoodTap;
//   final Function() onLocationTap;
//   final Function() onTagTap;

//   const CustomBottomSheet({
//     super.key,
//     required this.onMoodTap,
//     required this.onLocationTap,
//     required this.onTagTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         ListTile(
//           leading: const Icon(Icons.mood),
//           title: const Text('기분/활동'),
//           onTap: onMoodTap,
//         ),
//         ListTile(
//           leading: const Icon(Icons.location_on),
//           title: const Text('위치 추가'),
//           onTap: onLocationTap,
//         ),
//         ListTile(
//           leading: const Icon(Icons.person),
//           title: const Text('사람 태그'),
//           onTap: onTagTap,
//         ),
//       ],
//     );
//   }
// }
