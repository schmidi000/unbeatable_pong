import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ball.dart';
import 'computer_controlled_paddle.dart';
import 'player_controlled_paddle.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final testGame = TestGame();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(
      GameWidget(
        game: testGame,
        overlayBuilderMap: {
          'game_over': (context, game) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  testGame.restartGame();
                },
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Game Over!',
                        style: TextStyle(fontSize: 30.0),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/images/retry_button.png',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        },
      ),
    );
  });
}

class TestGame extends FlameGame with HasCollidables, HasDraggables {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    restartGame();
  }

  /// Gets called when the user loses the game.
  void gameOver() {
    overlays.add('game_over');
    pauseEngine();
  }

  /// Cleans all children and restarts the game.
  void restartGame() {
    children.clear();
    final ball = Ball(gameOver);
    add(ScreenCollidable());
    add(ComputerControlledPaddle(ball));
    add(PlayerControlledPaddle());
    add(ball);
    if (overlays.isActive('game_over')) {
      overlays.remove('game_over');
      resumeEngine();
    }
  }

  @override
  Color backgroundColor() {
    return Colors.white;
  }
}
