import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'flappy_logo_game.dart';
import 'pipe.dart';

class Player extends PositionComponent
    with HasGameReference<FlappyLogoGame>, CollisionCallbacks {
  double _speed = 0;
  final double _gravity = 800;
  final double _flyForce = -300;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final playerImage = await game.images.load('2.jpg');
    final double playerWidth = 50;
    final double playerHeight = 50;
    size = Vector2(playerWidth, playerHeight);
    add(SpriteComponent(
      sprite: Sprite(playerImage),
      size: Vector2(playerWidth, playerHeight),
    ));
    anchor = Anchor.center;
    add(CircleHitbox());
  }

  @override
  void onMount() {
    super.onMount();
    position = Vector2(100, game.size.y / 2);
  }

  void flyUp() {
    _speed = _flyForce;
  }

  @override
  void update(double dt) {
    if (game.gameManager.isGameOver) {
      return;
    }
    super.update(dt);
    _speed += _gravity * dt;
    y += _speed * dt;

    // Check for collisions with the top and bottom of the screen
    if (y < 0 || y > game.size.y - size.y) {
      game.gameOver();
    }
  }

  void reset() {
    _speed = 0;
    if (isMounted) {
      position = Vector2(100, game.size.y / 2);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Pipe) {
      game.gameOver();
    }
  }
}
