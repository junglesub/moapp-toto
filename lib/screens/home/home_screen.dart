import 'package:flutter/material.dart';
import 'package:moapp_toto/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      // Handle the selected date
      print("Selected date: $selectedDate");
    }
  }

  Widget _buildPostCard({
    // required String profileName,
    required String authorName,
    required String date,
    required String content,
    String? imageUrl,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile and Author
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$date",
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            // Content
            Text(content),
            const SizedBox(height: 12.0),
            // Image
            if (imageUrl != null)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            const SizedBox(height: 12.0),
            // Emotion Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.thumb_down),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today, Together"),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "T # P ###",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar icon
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
          // Beige background with text
          Container(
            width: double.infinity,
            height: 20,
            color: Colors.yellow[100],
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Text(
              "누적 일기 ##개째...",
              style: TextStyle(fontSize: 14),
            ),
          ),
          // Scrollable area with posts
          Expanded(
            child: ListView(
              children: [
                _buildPostCard(
                  authorName: "Author A",
                  date: "2024년 11월 12일",
                  content: "오늘은 정말 좋은 날이었어요!",
                  imageUrl:
                      "https://via.placeholder.com/300", // Placeholder image
                ),
                _buildPostCard(
                  authorName: "Author B",
                  date: "2024년 11월 11일",
                  content: "Flutter로 멋진 앱을 만들었어요.",
                  imageUrl:
                      "https://via.placeholder.com/300", // Placeholder image
                ),
                _buildPostCard(
                  authorName: "Author C",
                  date: "2024년 11월 10일",
                  content: "오늘 날씨는 정말 쾌청했어요!",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
