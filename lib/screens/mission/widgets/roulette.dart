import 'dart:math';
import 'package:flutter/material.dart';
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
    "티켓 3개 제공",
    "티켓 5개 제공",
    "글자 5개 추가 제공",
    "글자 10개 추가 제공",
    "추가 기회 제공",
    "꽝 😢",
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('텍스트 룰렛'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
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
