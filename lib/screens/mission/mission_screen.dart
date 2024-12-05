import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:moapp_toto/provider/toto_provider.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:moapp_toto/screens/mission/widgets/roulette.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/screens/add/widgets/animated_btn_widget.dart';
import 'package:moapp_toto/utils/date_format.dart';
import 'package:moapp_toto/widgets/botttom_nav_bar.dart';
import 'package:provider/provider.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  int _currentIndex = 1;
  late ConfettiController _confettiController;
  bool _isHovered = false; // 마우스 hover 상태를 추적
  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  // 각 미션 버튼, onPressed 정의
  final List<Map<String, dynamic>> _buttonData = [
    {
      "text": "출석체크 하고 티켓 받기",
      "onPressed":
          (BuildContext context, ConfettiController? confettiController) {
        UserProvider up = Provider.of(context, listen: false);
        if (up.ue?.attendance.contains(formatDateToYYYYMMDD(DateTime.now())) ??
            true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("이미 오늘 출석체크를 했습니다."),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          up.ue?.addAttendance(DateTime.now());
          up.ue?.addTicket(1);
          up.ue?.addPoint(100);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("출석체크를 완료했습니다."),
              duration: Duration(seconds: 2),
            ),
          );

          // Trigger confetti
          confettiController?.play();
        }
      }
    },
    {
      "text": "랜덤 게임하고 티켓받기",
      "onPressed": (BuildContext context) {
        Navigator.pushNamed(context, '/game'); // 게임 페이지로 이동
      },
    },
    // {
    //   "text": "새로운 장소 인증하고 티켓받기 (누적 장소 00곳)",
    //   "onPressed": () => print("장소 인증 클릭됨")
    // },
    {
      "text": "광고 보고 티켓 받기",
      "onPressed": (BuildContext context) {
        Navigator.pushNamed(context, '/reward'); // 게임 페이지로 이동
      },
    },
    {"text": "친구 공유하고 티켓받기", "onPressed": () => print("친구 공유 클릭됨")},
  ];

  Widget _buildAccumulativeDiary(BuildContext context) {
    return Consumer2<UserProvider, TotoProvider>(
      builder: (context, up, tp, child) {
        int ticketCount = up.ue?.ticket ?? 0; // Reactive ticket count
        int pointCount = up.ue?.point ?? 0; // Reactive point count
        int diaryCount = tp.findByCreator(up.currentUser?.uid).length;

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
                  "🔥 누적 투투 $diaryCount개째...",
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number,
                          size: 16,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$ticketCount", // Reactive ticket count
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
                          "$pointCount", // Reactive point count
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider up = context.read();
    TotoProvider tp = context.read();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Today, Together"),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Column(
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
                    InkWell(
                      onTap: () {
                        // 룰렛 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RoulettePage(),
                          ),
                        );
                      },
                      child: MouseRegion(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Lottie 애니메이션
                            Container(
                              height: 150,
                              child: Lottie.asset(
                                'assets/animations/spinningWheel.json',
                                fit: BoxFit.fitWidth,
                                repeat: true,
                                animate: !_isHovered, // Hover 시 애니메이션 멈춤
                              ),
                            ),
                            // 텍스트 오버레이
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 6.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "룰렛 돌리러가기",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 두 번째 섹션: 티켓 받기
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "티켓 받기",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                                  onPressed: () => button["onPressed"](
                                      context, _confettiController), // 컨텍스트 전달
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
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter, // Adjust as needed
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality:
                    BlastDirectionality.explosive, // Random directions
                shouldLoop: false,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                colors: [
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.green
                ], // Customize colors
              ),
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
