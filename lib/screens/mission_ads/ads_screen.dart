/* 위에 있는 코드는 android / ios 환경에서는 유튜브 영상 가져오는게 잘 되지만 웹상으로는 오류가 있을 수 있음
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:moapp_toto/provider/user_provider.dart';
import 'package:provider/provider.dart';

class RewardAdPage extends StatefulWidget {
  @override
  _RewardAdPageState createState() => _RewardAdPageState();
}

class _RewardAdPageState extends State<RewardAdPage> {
  int countdown = 15;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startCountdown();

    // 영상이 시작될 때 카운트다운 시작
    // _controller.addListener(() {
    //   if (_controller.value.isPlaying && countdown > 0) {
    //     // 영상이 시작되면 카운트다운 시작
    //     if (timer == null || !timer!.isActive) {
    //       startCountdown();
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    timer?.cancel();
    // _controller.dispose();
    super.dispose();
  }

  void startCountdown() {
    debugPrint("startCountdown()");
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      debugPrint("Timer $countdown");
      if (countdown >= 1) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider up = context.watch();
    return Scaffold(
      appBar: AppBar(
        title: const Text('광고 보기'),
      ),
      body: Stack(
        children: [
          // 유튜브 플레이어
          Column(
            children: [
              PlayerWidget(),
              // 보상 버튼
              if (countdown == 0)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: () {
                      up.ue?.addTicket(1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("티켓을 받았습니다!")),
                      );
                      Navigator.pop(context); // 페이지 닫기
                    },
                    child: const Text("티켓 받기"),
                  ),
                ),
            ],
          ),

          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                countdown == 0 ? "보상이 지급되었습니다!" : "남은 시간: $countdown초",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Registering the view factory
    ui.platformViewRegistry.registerViewFactory(
      'youtube-player',
      (int id) => html.IFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..src = 'https://www.youtube.com/embed/xpXz107p8Gw?autoplay=1'
        ..allow = 'autoplay'
        ..style.border = 'none',
    );

    return SizedBox(
      height: 500,
      child: HtmlElementView(
        viewType: 'youtube-player',
      ),
    );
  }
}
