import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:myapp/flappy_logo_game.dart';

class GameOverPanel extends PositionComponent with HasGameReference<FlappyLogoGame> {
  @override
  Future<void> onLoad() async {
    // Background
    add(RectangleComponent(
      size: game.size,
      paint: Paint()..color = Colors.black.withOpacity(0.5),
    ));

    final newFontSize = game.size.x / 8;

    // "Game Over" text
    final gameOverText = TextComponent(
      text: 'GAME OVER',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: newFontSize, // Use dynamic font size
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
             Shadow(blurRadius: 8, color: Colors.black, offset: Offset(3, 3))
          ]
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, game.size.y / 3),
    );
    add(gameOverText);

    // Restart text
    final restartText = TextComponent(
        text: 'Tap to Restart',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        anchor: Anchor.center,
      position: Vector2(game.size.x / 2, game.size.y / 2 + 50),
    );
    add(restartText);
  }
}
