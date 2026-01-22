import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent with HasGameReference<FlameGame> {
  static final _paint = Paint()..color = const Color(0xFF654321); // A solid brown color
  static final _linePaint = Paint()
    ..color = const Color(0x88000000) // Semi-transparent black for texture
    ..strokeWidth = 2;

  late TextPainter _textPainter;
  late Offset _textOffset;

  @override
  Future<void> onLoad() async {
    size = Vector2(game.size.x, 100);
    position = Vector2(0, game.size.y - size.y);

    // Prepare the text painter
    const text = 'Powered by Lookers hup';
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(0.10),
      fontSize: 14,
      fontStyle: FontStyle.italic,
    );
    final textSpan = TextSpan(text: text, style: textStyle);
    _textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    _textPainter.layout();

    // Center the text on the ground
    _textOffset = Offset(
      (size.x - _textPainter.width) / 2,
      (size.y - _textPainter.height) / 2,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw the main ground rectangle
    canvas.drawRect(size.toRect(), _paint);

    // Draw some horizontal lines for a 3D effect
    for (double i = 0; i < size.y; i += 10) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.x, i),
        _linePaint, // Use a slightly darker paint for the lines
      );
    }

    // Draw the text
    _textPainter.paint(canvas, _textOffset);
  }
}
