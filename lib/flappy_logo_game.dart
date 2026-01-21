import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game_manager.dart';
import 'player.dart';
import 'pipe.dart';
import 'flap_button.dart';

class FlappyLogoGame extends FlameGame {
  late Player player;
  late GameManager gameManager;
  late TextComponent scoreText;
  late TextComponent gameOverText;
  late TextComponent poweredByText;
  Timer? pipeTimer;
  bool _isMounted = false;

  @override
  Future<void> onLoad() async {
    // Add the game manager
    add(gameManager = GameManager());

    // Player
    player = Player();
    add(player);

    // Score display
    scoreText = TextComponent(
      text: '0',
      anchor: Anchor.center,
    )..textRenderer = TextPaint(
        style: const TextStyle(fontSize: 40, color: Colors.white),
      );
    add(scoreText);

    // Game over text
    gameOverText = TextComponent(
      text: 'Game Over',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 60, color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );

    // Powered by text
    poweredByText = TextComponent(
      text: 'Powered with LookersHup',
      anchor: Anchor.bottomCenter,
    )..textRenderer = TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      );
    add(poweredByText);

    // Flap button
    add(FlapButton());

    super.onLoad();
  }

  @override
  void onMount() {
    if (!_isMounted) {
      // Background
      add(RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0xFFa2d2ff),
        priority: -1,
      ));

      // Ground
      add(RectangleComponent(
        position: Vector2(0, size.y - 100),
        size: Vector2(size.x, 100),
        paint: Paint()..color = const Color(0xFFb5838d),
        priority: -1,
      ));
      scoreText.position = Vector2(size.x / 2, 50);
      gameOverText.position = Vector2(size.x / 2, size.y / 2 - 100);
      poweredByText.position = Vector2(size.x / 2, size.y - 10);
      resetGame();
      _isMounted = true;
    }
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameManager.isGameOver) return;

    pipeTimer?.update(dt);

    // Ground collision
    if (player.y > size.y - 125) {
      player.y = size.y - 125;
      gameOver();
    }

    // Ceiling collision
    if (player.y < 25) {
      player.y = 0;
      gameOver();
    }

    // Check for collisions with pipes
    for (final child in children) {
      if (child is Pipe && player.toRect().overlaps(child.toRect())) {
        gameOver();
        return;
      }
    }

    // Update the score
    final pipes = children.whereType<Pipe>().toList();
    for (final pipe in pipes) {
      if (!pipe.scored && pipe.x + pipe.width < player.x) {
        pipe.scored = true;
        gameManager.increaseScore();
        scoreText.text = gameManager.score.toString();
      }
    }
  }

  void addPipePair() {
    final random = Random();
    final double pipeHeight = random.nextDouble() * (size.y - gameManager.pipeGap - 300) + 100;

    final topPipe = Pipe(
      position: Vector2(size.x, 0),
      size: Vector2(60, pipeHeight),
    );
    add(topPipe);

    final bottomPipe = Pipe(
      position: Vector2(size.x, pipeHeight + gameManager.pipeGap),
      size: Vector2(60, size.y - pipeHeight - gameManager.pipeGap),
    );
    add(bottomPipe);
  }

  void gameOver() {
    gameManager.isGameOver = true;
    pipeTimer?.stop();
    if (!children.contains(gameOverText)) {
      add(gameOverText);
    }
  }

  void resetGame() {
    gameManager.reset();
    player.reset();
    scoreText.text = '0';
    if (children.contains(gameOverText)) {
      remove(gameOverText);
    }

    // Remove all pipes
    final pipes = children.whereType<Pipe>().toList();
    for (var pipe in pipes) {
      pipe.removeFromParent();
    }

    // Restart the pipe timer
    pipeTimer?.stop();
    pipeTimer = Timer(1.5, repeat: true, onTick: addPipePair);
    pipeTimer?.start();
  }
}
