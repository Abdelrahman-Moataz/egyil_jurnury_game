import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'flappy_logo_game.dart';

class FlapButton extends CircleComponent with TapCallbacks, HasGameReference<FlappyLogoGame> {
  FlapButton() : super(radius: 40) {
    paint = Paint()..color = const Color(0xFFfcf6bd);
  }

  @override
  void onMount() {
    super.onMount();
    position = Vector2(game.size.x / 2 - 40, game.size.y - 120);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (game.gameManager.isGameOver) {
      game.resetGame();
    } else {
      game.player.flap();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.gameManager.isGameOver) {
      paint.color = const Color(0xFFff6961);
    } else {
      paint.color = const Color(0xFFfcf6bd);
    }
  }
}
