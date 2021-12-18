import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:unbeatable_pong/computer_controlled_paddle.dart';
import 'package:unbeatable_pong/player_controlled_paddle.dart';
import 'package:unbeatable_pong/sprite_change_effect.dart';

import 'main.dart';

/// The ball smiley. If the ball hits the left or right side of the screen or
/// one of the paddles, it simply ricochets.
/// If it hits the top or bottom side of the screen, it falls out of the map
/// and the user lost.
class Ball extends SpriteComponent
    with HasGameRef<UnbeatablePong>, HasHitboxes, Collidable {
  late final Sprite collisionSprite;

  // X and Y velocities of the ball
  // with the initial values, the ball goes to the
  // top right of the screen
  var velX = -2.8;
  var velY = -2.8;

  final VoidCallback gameOverCallback;

  Ball(VoidCallback gameOver)
      : this.gameOverCallback = gameOver,
        super(size: Vector2.all(70));

  @override
  Future<void> onLoad() async {
    collisionSprite = await Sprite.load('ball_scared.png');
    sprite = await Sprite.load('ball_happy.png');

    anchor = Anchor.center;

    final minX = 0.0 + size.x / 2;
    final maxX = gameRef.size.x - size.x / 2;

    final minY = gameRef.size.y / 3;
    final maxY = gameRef.size.y / 2;

    // the ball is positioned randomly within some given bounds defined
    // by minX, maxX, minY and maxY
    position = Vector2.copy(gameRef.size)
      ..x = Random().nextDouble() * (maxX - minX) + minX
      ..y = Random().nextDouble() * (maxY - minY) + minY;

    addHitbox(HitboxCircle());
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += 0.05;
    position
      ..x += velX
      ..y += velY;
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    add(SpriteChangeEffect(
        collisionSprite, EffectController(duration: 0.1, alternate: true)));

    if (collidedWithScreenOnAnySide(points, other)) {
      invertX();
    } else if (outOfScreen(points, other)) {
      gameOverCallback();
    } else if (collidedWithComputerControlledPaddle(points, other)) {
      invertY();
    } else if (other is PlayerControlledPaddle) {
      // ball collided on the left or right side of the paddle -> game over
      // the reason for this is because the default Flame collision detection does
      // not cover all edge cases. use flame_forge2d if you want more
      if (((position.y + size.y / 2) >= other.position.y) &&
          (position.x <= other.position.x ||
              position.x >= (other.position.x + other.size.x / 2))) {
        gameOverCallback();
      }
      invertY();
    } else {
      // in any other case, just invert the Y velocity
      invertY();
    }
  }

  /// Inverts the X velocity of the ball.
  void invertX() {
    velX *= -1;
  }

  /// Inverts the Y velocity of the ball.
  void invertY() {
    velY *= -1;
  }

  /// Returns true, if the ball collided with the left or right side of the screen.
  bool collidedWithScreenOnAnySide(Set<Vector2> points, Collidable other) {
    return other is ScreenCollidable &&
        (points.first.x <= 0.0 || points.first.x >= gameRef.size.x);
  }

  /// Returns true, if the ball either collided with the top or bottom side of the screen.
  /// In other words: The ball fell out of the map.
  bool outOfScreen(Set<Vector2> points, Collidable other) {
    return other is ScreenCollidable &&
        (points.first.y <= 0.0 || points.first.y >= gameRef.size.y);
  }

  /// Returns true, if the ball collided with the computer-controlled paddle.
  bool collidedWithComputerControlledPaddle(
      Set<Vector2> points, Collidable other) {
    return other is ComputerControlledPaddle;
  }
}
