import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../infra/models/particle.dart';
import '../../infra/models/particle_options.dart';
import 'animated_background.dart';
import 'behaviour.dart';
import 'particle_behaviour.dart';

/// Renders particles that move in a
/// predetermined direction on the [AnimatedBackground].
class RandomParticleBehaviour extends ParticleBehaviour {
  /// Creates a new random particle behaviour.
  RandomParticleBehaviour({
    ParticleOptions options = const ParticleOptions(),
    Paint? paint,
    Function(BuildContext, Offset)? onTap,
    Function(Duration)? duration,
  }) : super(options: options, paint: paint, onTap: onTap, duration: duration);

  static math.Random random = math.Random();

  @override
  void initFrom(Behaviour oldBehaviour) {
    super.initFrom(oldBehaviour);
    if (oldBehaviour is RandomParticleBehaviour || particles == null) {
      return;
    }
    particles!.forEach(initParticle);
  }

  @override
  void initParticle(Particle particle) {
    initPosition(particle);
    initRadius(particle);

    final double deltaSpeed = options.spawnMaxSpeed - options.spawnMinSpeed;
    final double speed =
        random.nextDouble() * deltaSpeed + options.spawnMinSpeed;
    initDirection(particle, speed);

    final double deltaOpacity = options.maxOpacity - options.minOpacity;
    particle
      ..alpha = options.spawnOpacity
      ..targetAlpha = random.nextDouble() * deltaOpacity + options.minOpacity;
  }

  /// Initializes a new position for the provided [Particle].
  @protected
  void initPosition(Particle p) => p
    ..cx = random.nextDouble() * size!.width
    ..cy = random.nextDouble() * size!.height;

  /// Initializes a new radius for the provided [Particle].
  @protected
  void initRadius(Particle p) {
    final double deltaRadius = options.spawnMaxRadius - options.spawnMinRadius;
    p.radius = random.nextDouble() * deltaRadius + options.spawnMinRadius;
  }

  /// Initializes a new direction for the provided [Particle].
  @protected
  void initDirection(Particle p, double speed) {
    final double dirX = random.nextDouble() - 0.5;
    final double dirY = random.nextDouble() - 0.5;
    final double magSq = dirX * dirX + dirY * dirY;
    final double mag = magSq <= 0 ? 1 : math.sqrt(magSq);
    p
      ..dx = dirX / mag * speed
      ..dy = dirY / mag * speed;
  }

  @override
  void onOptionsUpdate(ParticleOptions? oldOptions) {
    super.onOptionsUpdate(oldOptions);
    final double minSpeedSqr = options.spawnMinSpeed * options.spawnMinSpeed;
    final double maxSpeedSqr = options.spawnMaxSpeed * options.spawnMaxSpeed;
    if (particles == null) {
      return;
    }
    for (final Particle p in particles!) {
      // speed assignment is better done this way,
      // to prevent calculation of square roots if not needed
      final double speedSqr = p.speedSqr;
      if (speedSqr > maxSpeedSqr) {
        p.speed = options.spawnMaxSpeed;
      } else if (speedSqr < minSpeedSqr) {
        p.speed = options.spawnMinSpeed;
      }

      if (p.radius < options.spawnMinRadius ||
          p.radius > options.spawnMaxRadius) {
        initRadius(p);
      }
    }
  }
}
