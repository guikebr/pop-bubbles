import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

import '../../../domain/repositories/animated_background.dart';
import '../../../domain/repositories/behaviour.dart';

/// Holds the information of a line used in a [RacingLinesBehaviour].
class Line {
  /// The position of the start of this line.
  Offset? position;

  /// The speed of this line.
  late double speed;

  /// The thickness of this line.
  late int thickness;

  /// The color of this line.
  Color? color;
}

/// The direction in which the lines should move
enum LineDirection {
  /// Left to Right
  ltr,

  /// Right to Left
  rtl,

  /// Top to Bottom
  ttb,

  /// Bottom to Top
  btt,
}

/// Renders moving lines on an [AnimatedBackground].
class RacingLinesBehaviour extends Behaviour {
  /// Creates a new racing lines behaviour
  RacingLinesBehaviour({this.direction = LineDirection.ltr, int numLines = 50})
      : assert(numLines >= 0, 'numLines >= 0') {
    _numLines = numLines;
  }

  static final math.Random random = math.Random();

  /// The list of lines used by the behaviour to hold the spawned lines.
  @protected
  List<Line>? lines;

  int? _numLines;

  /// Gets the number of lines in the background.
  int? get numLines => _numLines;

  /// Sets the number of lines in the background.
  set numLines(int? value) {
    if (isInitialized) {
      if (value! > lines!.length) {
        lines!.addAll(generateLines(value - lines!.length));
      } else if (value < lines!.length) {
        lines!.removeRange(0, lines!.length - value);
      }
    }
    _numLines = value;
  }

  /// The direction in which the lines should move
  ///
  /// Changing this will cause all lines to move in this direction, but no
  /// animation will be performed to change the direction. The lines will
  @protected
  LineDirection direction;

  /// Generates an amount of lines and initializes them.
  @protected
  List<Line> generateLines(int numLines) => List<Line>.generate(
        numLines,
        (int i) {
          final Line line = Line();
          initLine(line);
          return line;
        },
      );

  /// Initializes a line for this behaviour.
  @protected
  void initLine(Line line) {
    line.speed = random.nextDouble() * 400 + 200;

    final bool axisHorizontal =
        direction == LineDirection.ltr || direction == LineDirection.rtl;
    final bool normalDirection =
        direction == LineDirection.ltr || direction == LineDirection.ttb;
    final double sizeCrossAxis = axisHorizontal ? size!.height : size!.width;
    final double sizeMainAxis = axisHorizontal ? size!.width : size!.height;
    final double spawnCrossAxis = random.nextInt(100) * (sizeCrossAxis / 100);
    double spawnMainAxis = 0;

    if (line.position == null) {
      spawnMainAxis = random.nextDouble() * sizeMainAxis;
    } else {
      spawnMainAxis = normalDirection
          ? (-line.speed / 2.0)
          : (sizeMainAxis + line.speed / 2.0);
    }

    line
      ..position = axisHorizontal
          ? Offset(spawnMainAxis, spawnCrossAxis)
          : Offset(spawnCrossAxis, spawnMainAxis)
      ..thickness = random.nextInt(2) + 2
      ..color = HSVColor.fromAHSV(
        random.nextDouble() * 0.3 + 0.2,
        random.nextInt(45) * 8.0,
        random.nextDouble() * 0.6 + 0.3,
        random.nextDouble() * 0.6 + 0.3,
      ).toColor();
  }

  @override
  void init() {
    lines = generateLines(numLines!);
  }

  @override
  void initFrom(Behaviour oldBehaviour) {
    if (oldBehaviour is RacingLinesBehaviour) {
      lines = oldBehaviour.lines;
      numLines = _numLines; // causes the lines to update
    }
  }

  @override
  bool get isInitialized => lines != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()..strokeCap = StrokeCap.round;
    final bool axisHorizontal =
        direction == LineDirection.ltr || direction == LineDirection.rtl;
    final int sign =
        (direction == LineDirection.ltr || direction == LineDirection.ttb)
            ? 1
            : -1;
    for (final Line line in lines!) {
      final ui.Offset tailDirection = axisHorizontal
          ? Offset(sign * line.speed / 2.0, 0)
          : Offset(0, sign * line.speed / 2.0);
      final ui.Offset headDelta =
          axisHorizontal ? Offset(20.0 * sign, 0) : Offset(0, 20.0 * sign);
      final ui.Offset target = line.position! + tailDirection;
      paint
        ..shader = ui.Gradient.linear(line.position!, target - headDelta,
            <Color>[line.color!.withAlpha(0), line.color!])
        ..strokeWidth = line.thickness.toDouble();
      canvas.drawLine(line.position!, target, paint);
    }
  }

  @override
  bool tick(double delta, Duration elapsed) {
    final bool axisHorizontal =
        direction == LineDirection.ltr || direction == LineDirection.rtl;
    final int sign =
        (direction == LineDirection.ltr || direction == LineDirection.ttb)
            ? 1
            : -1;
    if (axisHorizontal) {
      for (final Line line in lines!) {
        line.position = line.position!.translate(delta * line.speed * sign, 0);
        if ((direction == LineDirection.ltr &&
                line.position!.dx > size!.width) ||
            (direction == LineDirection.rtl && line.position!.dx < 0)) {
          initLine(line);
        }
      }
    } else {
      for (final Line line in lines!) {
        line.position = line.position!.translate(0, delta * line.speed * sign);
        if ((direction == LineDirection.ttb &&
                line.position!.dy > size!.height) ||
            (direction == LineDirection.btt && line.position!.dy < 0)) {
          initLine(line);
        }
      }
    }
    return true;
  }
}
