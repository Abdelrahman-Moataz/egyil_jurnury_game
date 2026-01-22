import 'dart:math';
import 'package:flame/components.dart' hide World;
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flutter/material.dart';
import 'game_manager.dart';
import 'game_over_panel.dart';
import 'player.dart';
import 'pipe.dart';
import 'world.dart';
import 'ground.dart';

class FlappyLogoGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  late Player player;
  late GameManager gameManager;
  late TextComponent scoreText;
  Timer? pipeTimer;

  @override
  Future<void> onLoad() async {
    // Game Manager
    gameManager = GameManager();
    add(gameManager);

    // World and Ground
    // These are part of the game world, so we add them directly.
    add(World());
    add(Ground());

    // Player
    player = Player();
    add(player);

    // Score - This is a HUD element and should be added to the viewport.
    scoreText = TextComponent(
      text: '0',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 50,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(blurRadius: 8, color: Colors.black, offset: Offset(3, 3))
          ],
        ),
      ),
    );
    camera.viewport.add(scoreText);

    await super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    scoreText.position = Vector2(size.x / 2, 80);
    resetGame();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameManager.isGameOver) return;

    pipeTimer?.update(dt);

    // Update score by iterating over a copy of the list
    for (final pipe in children.whereType<Pipe>().toList()) {
      if (!pipe.scored && pipe.x + pipe.width < player.x) {
        pipe.scored = true;
        gameManager.increaseScore();
        scoreText.text = gameManager.score.toString();
      }
    }
  }

  void addPipePair() {
    final random = Random();
    final double pipeHeight =
        random.nextDouble() * (size.y - gameManager.pipeGap - 350) + 150;

    add(Pipe(
      position: Vector2(size.x, 0),
      size: Vector2(90, pipeHeight),
      isTop: true,
    ));

    add(Pipe(
      position: Vector2(size.x, pipeHeight + gameManager.pipeGap),
      size: Vector2(90, size.y - pipeHeight - gameManager.pipeGap - 100),
      isTop: false,
    ));
  }

  void gameOver() {
    if (gameManager.isGameOver) return;
    gameManager.isGameOver = true;
    pipeTimer?.stop();
    // Add the GameOverPanel to the camera's viewport to make it a HUD element.
    camera.viewport.add(GameOverPanel());
  }

  void resetGame() {
    gameManager.reset();
    player.reset();
    scoreText.text = '0';
    // Remove the GameOverPanel from the viewport.
    camera.viewport.removeAll(camera.viewport.children.whereType<GameOverPanel>());
    // Remove all pipes from the game world.
    removeAll(children.whereType<Pipe>());
    pipeTimer?.stop();
    pipeTimer = Timer(2, repeat: true, onTick: addPipePair)..start();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (gameManager.isGameOver) {
      resetGame();
    } else {
      player.flyUp();
    }
  }
}
