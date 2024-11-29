import 'package:moapp_toto/screens/mission/widgets/roulette.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/screens/add/widgets/animated_btn_widget.dart';
import 'package:moapp_toto/widgets/botttom_nav_bar.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  int _currentIndex = 1;

  // 각 미션 버튼, onPressed 정의
  final List<Map<String, dynamic>> _buttonData = [
    {"text": "출석체크 하고 티켓 ( 00일째 )", "onPressed": () => print("출석체크 클릭됨")},
    {"text": "랜덤 운동하고 티켓받기", "onPressed": () => print("운동 클릭됨")},
    {
      "text": "새로운 장소 인증하고 티켓받기 (누적 장소 00곳)",
      "onPressed": () => print("장소 인증 클릭됨")
    },
    {"text": "광고 보고 티켓 받기", "onPressed": () => print("광고 클릭됨")},
    {"text": "친구 공유하고 티켓받기", "onPressed": () => print("친구 공유 클릭됨")},
  ];

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
          Container(
            width: double.infinity,
            height: 30,
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
                // 첫 번째 섹션: 룰렛 돌리기
                GestureDetector(
                  onTap: () {
                    // 룰렛 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoulettePage(),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 150,
                      alignment: Alignment.center,
                      child: const Text(
                        "룰렛 돌리기",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "남은 티켓: 3장",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                // 두 번째 섹션: 티켓 받기
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "티켓 받기 (수령 가능 티켓수 10장)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      ..._buttonData.map((button) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: CustomAnimatedButton(
                              text: button["text"],
                              onPressed: button["onPressed"],
                            ),
                          )),
                    ],
                  ),
                )
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
