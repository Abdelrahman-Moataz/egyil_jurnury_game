import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Pipe extends PositionComponent with HasGameReference<FlameGame>, CollisionCallbacks {
  final bool isTop;
  bool scored = false;

  Pipe({required super.position, required super.size, required this.isTop});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Rect rect = size.toRect();
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFF74BF2E), // A vibrant green
          const Color(0xFF5A9E25), // A slightly darker green for depth
        ],
      ).createShader(rect);

    canvas.drawRect(rect, paint);

    // Add a highlight for a 3D effect
    final Rect highlightRect = Rect.fromLTWH(rect.left + 5, rect.top + 5, rect.width - 10, 10);
    final Paint highlightPaint = Paint()..color = Colors.white.withOpacity(0.5);
    canvas.drawRRect(RRect.fromRectAndRadius(highlightRect, const Radius.circular(5)), highlightPaint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= 200 * dt; // Move the pipe to the left
    if (x < -width) {
      removeFromParent();
    }
  }
}
