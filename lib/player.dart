import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'flappy_logo_game.dart';

class Player extends CircleComponent with HasGameReference<FlappyLogoGame> {
  double velocity = 0.0;
  double gravity = 0.0;
  late ui.Image _image;
  bool _imageLoaded = false;

  Player() : super(radius: 25);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _image = await game.images.load('2.jpg');
    _imageLoaded = true;
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    if (_imageLoaded) {
      final circlePath = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));
      canvas.clipPath(circlePath);
      paintImage(
        canvas: canvas,
        rect: Rect.fromCircle(center: Offset.zero, radius: radius),
        image: _image,
        fit: BoxFit.cover ,
      );
    }
  }

  @override
  void onMount() {
    super.onMount();
    position = Vector2(100, game.size.y / 2);
  }

  void flap() {
    velocity = -10.0;
    gravity = 0.0;
  }

  @override
  void update(double dt) {
    if (game.gameManager.isGameOver) {
      return;
    }
    super.update(dt);
    velocity += gravity;
    gravity += 0.3;
    y += velocity;
  }

  void reset() {
    velocity = 0.0;
    gravity = 0.0;
    if (isMounted) {
      position = Vector2(100, game.size.y / 2);
    }
  }
}
