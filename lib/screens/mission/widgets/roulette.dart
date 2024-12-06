import 'dart:math';
import 'package:flutter/material.dart';
import 'package:moapp_toto/constants.dart';
import 'package:moapp_toto/provider/toto_provider.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:roulette/roulette.dart';
import 'arrow.dart';

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
    {"text": "100 포인트", "type": "point", "value": 100, "weight": 1},
    {"text": "50 포인트", "type": "point", "value": 50, "weight": 2},
    {"text": "티켓 2개", "type": "ticket", "value": 2, "weight": 1},
    {"text": "200 포인트", "type": "point", "value": 200, "weight": 0.5},
    {"text": "20 포인트", "type": "point", "value": 20, "weight": 3},
    {"text": "250 포인트", "type": "point", "value": 250, "weight": 0.2},
  ];

  late final RouletteGroup group = RouletteGroup.uniform(
    options.length,
    colorBuilder: (index) => index % 2 == 0 ? Colors.red! : Colors.orange!,
    textBuilder: (index) => options[index]["text"] as String,
    textStyleBuilder: (index) => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );

  void _onResult(int selectedIndex) {
    final selectedOption = options[selectedIndex]["text"];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('결과: $selectedOption')),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider up = context.read();
    // int ticketCount = up.ue?.ticket ?? 0; // Reactive ticket count
    // int pointCount = up.ue?.point ?? 0; // Reactive point count
    return Scaffold(
      appBar: AppBar(
        title: const Text('룰렛 돌리기'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black!
              : whiteBackgroundColor,
        ),
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
                  child: Consumer<UserProvider>(
                    builder: (context, up, child) {
                      final ticketCount = up.ue?.ticket ?? 0;
                      final pointCount = up.ue?.point ?? 0;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.confirmation_number,
                            size: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$ticketCount",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.stars,
                            size: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$pointCount",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // 룰렛 위젯
              const SizedBox(height: 4),
              MyRoulette(
                group: group,
                controller: _controller,
              ),
              const SizedBox(height: 40),
              // ROLL 버튼
              Align(
                alignment: Alignment.center, // 버튼을 가운데 정렬
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 150, // 버튼의 최대 너비 설정 (텍스트 길이에 따라 조정)
                  ),
                  child: FilledButton(
                    onPressed: () async {
                      if ((up.ue?.ticket ?? 0) <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('티켓이 없습니다!')),
                        );
                        return;
                      }
                      up.ue?.removeTicket(1);

                      final selectedIndex = getWeightedRandomIndex(options);
                      final completed = await _controller.rollTo(
                        selectedIndex,
                        clockwise: _clockwise,
                        offset: _random.nextDouble(),
                      );

                      if (completed) {
                        _onResult(selectedIndex);

                        final selectedOption = options[selectedIndex]["type"];
                        final selectedValue =
                            options[selectedIndex]["value"] as int;
                        if (selectedOption == "point") {
                          up.ue?.addPoint(selectedValue);
                        } else if (selectedOption == "ticket") {
                          up.ue?.addTicket(selectedValue);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Animation cancelled')),
                        );
                      }
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.amber),
                    ),
                    child: Text(
                      '룰렛 돌리기',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
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
        const Arrow(),
      ],
    );
  }
}

int getWeightedRandomIndex(List<Map<String, dynamic>> options) {
  final totalWeight = options.fold<double>(
    0,
    (sum, option) => sum + (option["weight"] as num).toDouble(),
  );

  final randomValue = Random().nextDouble() * totalWeight;

  double cumulativeWeight = 0;
  for (int i = 0; i < options.length; i++) {
    cumulativeWeight += (options[i]["weight"] as num).toDouble();
    if (randomValue <= cumulativeWeight) {
      return i;
    }
  }

  return options.length - 1; // Fallback in case of rounding issues
}
