import 'dart:ui';

import 'package:equatable/equatable.dart';

class Bubble extends Equatable {
  Bubble(
    this.colour,
    this.direction,
    this.radius, {
    this.speed = 1,
    this.x = 0,
    this.y = 0,
  });

  final Color colour;
  double direction, radius, speed, x, y;

  @override
  List<Object?> get props => <Object?>[colour, direction, x, y, speed, radius];
}
