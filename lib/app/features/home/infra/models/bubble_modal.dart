import 'dart:math';
import 'dart:ui';

import '../../domain/entities/bubble.dart';

import '../../domain/entities/bubble_info.dart';

class BubbleModal extends Bubble implements BubbleInfo {
  // direction = Random().nextDouble() * 360;
  // radius = Random().nextDouble() * maxBubbleSize;
  // speed = 1;
  // x = 0;
  // y = 0;
  BubbleModal(
    Color color,
    double direction,
    double radius, {
    double speed = 1,
    double x = 0,
    double y = 0,
  }) : super(color, direction, radius, speed: speed, x: x, y: y);

  void draw(Canvas canvas, Size canvasSize) {
    final Paint paint = Paint()
      ..color = colour
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    assignRandomPositionIfUninitialized(canvasSize);

    randomlyChangeDirectionIfEdgeReached(canvasSize);

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void assignRandomPositionIfUninitialized(Size canvasSize) {
    if (x == 0) {
      x = Random().nextDouble() * canvasSize.width;
    }
    if (y == 0) {
      y = Random().nextDouble() * canvasSize.height;
    }
  }

  void randomlyChangeDirectionIfEdgeReached(Size canvasSize) {
    if (x > canvasSize.width || x < 0 || y > canvasSize.height || y < 0) {
      direction = Random().nextDouble() * 360;
    }
  }

  void updatePosition() {
    final double a = 180 - (direction + 90);

    direction > 0 && direction < 180
        ? x += speed * sin(direction) / sin(speed)
        : x -= speed * sin(direction) / sin(speed);

    direction > 90 && direction < 270
        ? y += speed * sin(a) / sin(speed)
        : y -= speed * sin(a) / sin(speed);
  }
}
