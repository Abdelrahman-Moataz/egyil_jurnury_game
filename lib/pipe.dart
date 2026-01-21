import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'flappy_logo_game.dart';

class Pipe extends RectangleComponent with HasGameReference<FlappyLogoGame> {
  bool scored = false;

  Pipe({required Vector2 position, required Vector2 size}) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    paint = Paint()..color = const Color(0xFFcdb4db);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.gameManager.isGameOver) {
      return;
    }
    x -= game.gameManager.gameSpeed * dt;

    if (x < -width) {
      if (isMounted) {
        removeFromParent();
      }
    }
  }
}
