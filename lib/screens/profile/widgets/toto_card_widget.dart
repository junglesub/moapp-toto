import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ToToCard extends StatelessWidget {
  final String userName;
  final String userImagePath;
  final String postDate;
  final String postContent;
  final String postImagePath;

  const ToToCard({
    super.key,
    required this.userName,
    required this.userImagePath,
    required this.postDate,
    required this.postContent,
    required this.postImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(userImagePath),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      postDate,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              postContent,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                postImagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 1000.ms)
        .slideY(begin: 0.1, end: 0, duration: 1000.ms);
  }
}
