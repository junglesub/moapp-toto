import 'package:flutter/material.dart';
import 'package:moapp_toto/widgets/botttom_nav_bar.dart';
import 'package:moapp_toto/widgets/custom_button.dart';
// import 'package:moapp_toto/widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      print("Selected date: $selectedDate");
    }
  }

  Widget _buildPostCard({
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
            Text(content),
            const SizedBox(height: 12.0),
            if (imageUrl != null)
              Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            const SizedBox(height: 12.0),
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
                "T 5 P 100",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
          Container(
            width: double.infinity,
            height: 20,
            color: Colors.yellow[100],
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Text(
              "🔥 누적 일기 16개째...",
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildPostCard(
                  authorName: "Author A",
                  date: "2024년 11월 12일",
                  content: "오늘은 날씨가 너무 좋았다!!",
                  imageUrl: "assets/images/toto.jpg",
                ),
                _buildPostCard(
                  authorName: "Author B",
                  date: "2024년 11월 11일",
                  content: "플러터로 앱 개발을 함. 굿",
                  imageUrl: "assets/images/toto.jpg",
                ),
                _buildPostCard(
                  authorName: "Author C",
                  date: "2024년 11월 10일",
                  content: "드라이브해서 바다 보고옴",
                ),
              ],
            ),
          ),
        ],
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
