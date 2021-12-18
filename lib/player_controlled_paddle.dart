import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'main.dart';

/// Paddle that is controlled by the player by dragging.
class PlayerControlledPaddle extends RectangleComponent
    with HasGameRef<TestGame>, Collidable, Draggable {
  PlayerControlledPaddle()
      : super(
          position: Vector2(0.0, 0.0),
          size: Vector2(100.0, 20.0),
          paint: PaintExtension.fromRGBHexString('#AAAAAA'),
        );

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    position = Vector2.copy(gameRef.size)
      ..x /= 2
      ..y /= 1.08;
  }

  /// Updates the X coordinate of the paddle, whenever the user drags it.
  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo event) {
    final localCoords = event.eventPosition.game;

    final minX = 0.0 + size.x / 2;
    final maxX = gameRef.size.x - size.x / 2;

    position.x = localCoords.x < minX
        ? minX
        : (localCoords.x > maxX ? maxX : localCoords.x);

    return false;
  }
}
