import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'ball.dart';
import 'main.dart';

/// Paddle that is controlled by the computer.
class ComputerControlledPaddle extends RectangleComponent
    with HasGameRef<UnbeatablePong>, Collidable {
  Ball ball;

  ComputerControlledPaddle(Ball ball)
      : this.ball = ball,
        super(
          position: Vector2(0.0, 0.0),
          size: Vector2(100.0, 20.0),
          paint: PaintExtension.fromRGBHexString('#000000'),
        );

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    // initial position of the paddle
    position = Vector2.copy(gameRef.size)
      ..x = ball.position.x
      ..y /= 10;
  }

  /// The paddle follows the ball by updating the X coordinate to the X coordinate
  /// of the ball.
  @override
  void update(double dt) {
    final minX = 0.0 + size.x / 2;
    final maxX = gameRef.size.x - size.x / 2;

    if (ball.position.x < minX) {
      position.x = minX;
    } else if (ball.position.x > maxX) {
      position.x = maxX;
    } else {
      position.x = ball.position.x;
    }
  }
}
