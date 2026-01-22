import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class World extends Component with HasGameReference<FlameGame> {
  @override
  void render(Canvas canvas) {
    final Rect rect = Rect.fromLTWH(0, 0, game.size.x, game.size.y);
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0077BE), // A nice sky blue
          Color(0xFF87CEEB), // A lighter, softer blue at the horizon
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }
}
