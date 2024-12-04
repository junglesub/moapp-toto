import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:moapp_toto/provider/toto_provider.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:moapp_toto/screens/mission/widgets/roulette.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/screens/add/widgets/animated_btn_widget.dart';
import 'package:moapp_toto/widgets/botttom_nav_bar.dart';
import 'package:provider/provider.dart';

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
    {
      "text": "랜덤 게임하고 티켓받기",
      "onPressed": (BuildContext context) {
        Navigator.pushNamed(context, '/game'); // 게임 페이지로 이동
      },
    },
    {
      "text": "새로운 장소 인증하고 티켓받기 (누적 장소 00곳)",
      "onPressed": () => print("장소 인증 클릭됨")
    },
    {
      "text": "광고 보고 티켓 받기",
      "onPressed": (BuildContext context) {
        Navigator.pushNamed(context, '/reward'); // 게임 페이지로 이동
      },
    },
    {"text": "친구 공유하고 티켓받기", "onPressed": () => print("친구 공유 클릭됨")},
  ];

  Widget _buildAccumulativeDiary(BuildContext context) {
    UserProvider up = context.read();
    TotoProvider tp = context.read();

    int ticketCount = 5; //파이어베이스랑 티켓정보 연결
    int pointCount = 100; //

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Accumulative diary text
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.amber,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Text(
              "🔥 누적 투투 ${tp.findByCreator(up.currentUser?.uid).length}개째...",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              // Ticket and Point box
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(255, 143, 0, 1),
                      Colors.yellow,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.confirmation_number,
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$ticketCount", // <<< 나중에 티켓 숫자 집어넣기>>>
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Coin icon and count
                    const Icon(
                      Icons.stars, // Use coin-like icon
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$pointCount", // Point count
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Calendar icon
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider up = context.read();
    TotoProvider tp = context.read();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today, Together"),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccumulativeDiary(context),
          Divider(
            thickness: 2,
            // color: Color.fromARGB(255, 245, 245, 245),
            color: Theme.of(context).dividerColor,
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
                            child: ElevatedButton(
                              onPressed: () =>
                                  button["onPressed"](context), // 컨텍스트 전달
                              child: Text(button["text"]),
                              // text: button["text"],
                              // onPressed: button["onPressed"],
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
