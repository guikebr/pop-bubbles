import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/repositories/particle_behaviour.dart';

/// Holds the information of a particle used in a [ParticleBehaviour].
class Particle {
  /// Constructs a new [Particle] with its default values.
  Particle();

  /// The X coordinate of the center of this particle.
  double cx = 0;

  /// The Y coordinate of the center of this particle.
  double cy = 0;

  /// The X component of the direction of this particle. This is usually scaled
  /// by the speed of the particle, make it a non-normalized
  /// component of direction.
  double dx = 0;

  /// The Y component of the direction of this particle This is usually scaled
  /// by the speed of the particle, make it a non-normalized
  /// component of direction.
  double dy = 1;

  /// The radius of this particle.
  ///
  /// If a [ParticleBehaviour] draws particles with images this value represents
  /// half the width and height of this particle.
  double radius = 0;

  /// The current alpha value of this particle.
  double alpha = 0;

  /// The color of this particle.
  Color color = Colors.transparent;

  /// The target alpha of this particle.
  double targetAlpha = 0;

  /// Dynamic data that can be used by [ParticleBehaviour] classes to store
  /// other information related to the particles.
  dynamic data;

  /// The state of the particle. Is it popping?
  late bool popping;

  /// Gets the square of the speed of this particle.
  double get speedSqr => dx * dx + dy * dy;

  /// Sets the square of the speed of this particle.
  ///
  /// If a negative value is provided the direction is flipped and the absolute
  /// value is used to calculate the square root.
  set speedSqr(double value) {
    speed = math.sqrt(value.abs()) * value.sign;
  }

  /// Gets the speed of this particle.
  double get speed => math.sqrt(speedSqr);

  /// Sets the speed of this particle.
  ///
  /// In case the value is 0, the Y component of the direction will be set to 1
  /// making the speed of the particle 1, instead of 0. The logic behind this
  /// implementation is as follows: The Particle Behaviour needs to the
  /// smallest amount of work for each particle as possible. If a speed field
  /// was provided to specify the velocity of the particle, it would require the
  /// 2 additional multiplications (one for each component of direction) when
  /// updating a particle.
  set speed(double value) {
    final double mag = speed;
    if (mag == 0) {
      dx = 0.0;
      dy = value;
    } else {
      dx = dx / mag * value;
      dy = dy / mag * value;
    }
  }
}
