import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:moapp_toto/screens/mission_game/widgets/brick_breaker.dart';
import 'package:provider/provider.dart';

// class GamePage extends StatelessWidget {
//   const GamePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Game'),
//       ),
//       body: GameWidget(
//         game: BrickBreaker(),
//         // game: FlameGame(world: MyWorld()),
//       ),
//     );
//   }
// }

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("벽돌깨기"),
      ),
      body: GameWidget(
        game: BrickBreaker(),
        overlayBuilderMap: {
          'welcome': (context, game) =>
              _buildWelcomeOverlay(context, game as BrickBreaker),
          'gameOver': (context, game) =>
              _buildGameOverOverlay(context, game as BrickBreaker),
          'won': (context, game) => _buildWonOverlay(
              context, game as BrickBreaker), //게임에서 이기면 티켓 1장 주기 ...
        },
      ),
    );
  }

  Widget _buildWelcomeOverlay(BuildContext context, BrickBreaker game) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Welcome to Brick Breaker!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: game.startGame,
            child: const Text("Start Game"),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(BuildContext context, BrickBreaker game) {
    UserProvider up = context.watch();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Game Over!\n${game.score.value} 글자 획득!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              up.ue?.addPoint(game.score.value);
              print("${game.score.value} 적립");
              game.startGame();
            },
            child: const Text("리워드 받고 재도전"),
          ),
          SizedBox(height: 4),
          ElevatedButton(
            onPressed: () {
              up.ue?.addPoint(game.score.value);
              print("${game.score.value} 적립");
              Navigator.pop(context);
            },
            child: const Text("리워드 받고 끝내기"),
          ),
        ],
      ),
    );
  }

  Widget _buildWonOverlay(BuildContext context, BrickBreaker game) {
    UserProvider up = context.watch();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "이겼습니다!\n${game.score.value} 글자 획득!\n보너스 티켓 1장 획득",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              print("${game.score.value} 적립 + 티켓");
              up.ue?.addPoint(game.score.value);
              up.ue?.addTicket(1);
              Navigator.pop(context);
            },
            child: const Text("리워드 받기"),
          ),
        ],
      ),
    );
  }
}
