import 'package:flutter/material.dart';

import '../../features/game/domain/repositories/animated_background.dart';
import '../../features/game/domain/repositories/behaviour.dart';

/// Empty Behaviour that renders nothing on an [AnimatedBackground]
class EmptyBehaviour extends Behaviour {
  factory EmptyBehaviour() => _empty ?? (_empty = EmptyBehaviour._());

  EmptyBehaviour._();

  static EmptyBehaviour? _empty;

  @override
  void init() {}

  @override
  void initFrom(Behaviour oldBehaviour) {}

  @override
  bool get isInitialized => true;

  @override
  void paint(PaintingContext context, Offset offset) {}

  @override
  bool tick(double delta, Duration elapsed) => false;
}
