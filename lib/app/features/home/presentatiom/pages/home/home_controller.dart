import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infra/models/bubble_modal.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController animationController;
  late List<BubbleModal> bubbles;

  final int numberOfBubbles = 20;
  final double maxBubbleSize = 12;

  @override
  void onInit() {
    super.onInit();
    int i = numberOfBubbles;
    bubbles = <BubbleModal>[];
    while (i > 0) {
      bubbles.add(BubbleModal(
        (<Color>[...Colors.primaries]..shuffle()).first,
        Random().nextDouble() * 360,
        Random().nextDouble() * maxBubbleSize,
      ));
      i--;
    }
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1500),
    );
    animationController
      ..addListener(updateBubblePosition)
      ..forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void updateBubblePosition() {
    for (final BubbleModal bubble in bubbles) {
      bubble.updatePosition();
    }
    update();
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter({required this.bubbles, required this.controller});

  final List<BubbleModal> bubbles;
  final AnimationController controller;

  @override
  void paint(Canvas canvas, Size size) {
    for (final BubbleModal bubble in bubbles) {
      bubble.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
