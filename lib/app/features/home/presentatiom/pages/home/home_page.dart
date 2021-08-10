import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Bubbles();
  }
}

class Bubbles extends StatefulWidget {
  const Bubbles({Key? key}) : super(key: key);

  @override
  _BubblesState createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Bubble> bubbles;

  final int numberOfBubbles = 20;
  final Color color = Colors.pink;
  final double maxBubbleSize = 30;

  @override
  void initState() {
    super.initState();
    int i = numberOfBubbles;
    bubbles = <Bubble>[];
    while (i > 0) {
      bubbles.add(Bubble(color, maxBubbleSize));
      i--;
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1500),
    );
    _controller
      ..addListener(updateBubblePosition)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: const <Widget>[
                SizedBox(height: 200),
                Text(
                  'Guike',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 40,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'The pop bubbles',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          CustomPaint(
            foregroundPainter: BubblePainter(
              bubbles: bubbles,
              controller: _controller,
            ),
            size: Size(Get.size.width, Get.size.height),
          ),
        ],
      ),
    );
  }

  void updateBubblePosition() {
    for (final Bubble bubble in bubbles) {
      bubble.updatePosition();
    }
    setState(() {});
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('numberOfBubbles', numberOfBubbles))
      ..add(DoubleProperty('maxBubbleSize', maxBubbleSize))
      ..add(ColorProperty('color', color))
      ..add(IterableProperty<Bubble>('bubbles', bubbles));
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter({required this.bubbles, required this.controller});

  List<Bubble> bubbles;
  AnimationController controller;

  @override
  void paint(Canvas canvas, Size size) {
    for (final Bubble bubble in bubbles) {
      bubble.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Bubble {
  Bubble(this.colour, double maxBubbleSize) {
    direction = Random().nextDouble() * 360;
    speed = 5;
    x = 0;
    y = 0;
    radius = Random().nextDouble() * maxBubbleSize;
  }

  late Color colour;
  late double direction, speed, radius;
  late double x, y;

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
