import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:moapp_toto/screens/mission_game/widgets/brick_breaker.dart';

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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Game Over!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              game.startGame();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildWonOverlay(BuildContext context, BrickBreaker game) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "이겼습니다!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
// 티켓 수령하고 미션페이지로 이동...
            },
            child: const Text("티켓 1개 받기"),
          ),
        ],
      ),
    );
  }
}
