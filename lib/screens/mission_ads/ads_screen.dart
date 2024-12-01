/* 위에 있는 코드는 android / ios 환경에서는 유튜브 영상 가져오는게 잘 되지만 웹상으로는 오류가 있을 수 있음
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RewardAdPage extends StatefulWidget {
  @override
  _RewardAdPageState createState() => _RewardAdPageState();
}

class _RewardAdPageState extends State<RewardAdPage> {
  late YoutubePlayerController _controller;
  int countdown = 15;
  bool rewardAvailable = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // 유튜브 컨트롤러 초기화
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          'https://www.youtube.com/watch?v=xpXz107p8Gw')!,
      flags: const YoutubePlayerFlags(
        autoPlay: true, //
        mute: false,
      ),
    );

    // 영상이 시작될 때 카운트다운 시작
    _controller.addListener(() {
      if (_controller.value.isPlaying && countdown > 0) {
        // 영상이 시작되면 카운트다운 시작
        if (timer == null || !timer!.isActive) {
          startCountdown();
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        setState(() {
          countdown--;
        });
      } else {
        setState(() {
          rewardAvailable = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('광고 보기'),
      ),
      body: Stack(
        children: [
          // 유튜브 플레이어
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
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
                rewardAvailable ? "보상이 지급되었습니다!" : "남은 시간: $countdown초",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),

          // 보상 버튼
          if (rewardAvailable)
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
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
    );
  }
}
