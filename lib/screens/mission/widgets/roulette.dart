import 'dart:math';
import 'package:flutter/material.dart';
import 'package:moapp_toto/provider/toto_provider.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:roulette/roulette.dart';

class RoulettePage extends StatefulWidget {
  const RoulettePage({Key? key}) : super(key: key);

  @override
  State<RoulettePage> createState() => _RoulettePageState();
}

class _RoulettePageState extends State<RoulettePage> {
  static final _random = Random();
  final _controller = RouletteController();
  bool _clockwise = true;

  // Define the options for the roulette
  final options = [
    "포인트 1개",
    "포인트 3개",
    "티켓 1개",
    "포인트 5개",
    "포인트 10개",
    "포인트 1개",
  ];

  late final RouletteGroup group = RouletteGroup.uniform(
    options.length,
    colorBuilder: (index) =>
        index % 2 == 0 ? Colors.yellow[100]! : Colors.orange[100]!,
    textBuilder: (index) => options[index],
    textStyleBuilder: (index) => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );

  void _onResult(int selectedIndex) {
    final selectedOption = options[selectedIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('결과: $selectedOption')),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider up = context.read();
    TotoProvider tp = context.read();
    int ticketCount = up.ue?.ticket ?? 0; // Reactive ticket count
    int pointCount = up.ue?.point ?? 0; // Reactive point count
    return Scaffold(
      appBar: AppBar(
        title: const Text('룰렛 돌리기'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
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
                    mainAxisSize: MainAxisSize.min,
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
              ),
              // 룰렛 위젯
              MyRoulette(
                group: group,
                controller: _controller,
              ),
              const SizedBox(height: 40),
              // ROLL 버튼
              FilledButton(
                onPressed: () async {
                  final selectedIndex = _random.nextInt(options.length);
                  final completed = await _controller.rollTo(
                    selectedIndex,
                    clockwise: _clockwise,
                    offset: _random.nextDouble(),
                  );

                  if (completed) {
                    _onResult(selectedIndex);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Animation cancelled')),
                    );
                  }
                },
                child: const Text('룰렛 돌리기'),
              ),
              // 방향 토글
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "시계 방향: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  Checkbox(
                    value: _clockwise,
                    onChanged: (value) {
                      setState(() {
                        _clockwise = value ?? true;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MyRoulette extends StatelessWidget {
  const MyRoulette({
    Key? key,
    required this.controller,
    required this.group,
  }) : super(key: key);

  final RouletteGroup group;
  final RouletteController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Roulette(
              group: group,
              controller: controller,
              style: const RouletteStyle(
                dividerThickness: 2.3,
                dividerColor: Colors.white,
                centerStickSizePercent: 0.05,
                centerStickerColor: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
