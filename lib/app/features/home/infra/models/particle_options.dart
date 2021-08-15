import 'package:flutter/material.dart';
import '../../domain/repositories/particle_behaviour.dart';

/// Dummy [Image] that represents a parameter not set. Used by
/// [ParticleOptions.copyWith] to check if the parameter was set or not.
class _NotSetImage extends Image {
  const _NotSetImage() : super(image: const _NotSetImageProvider());
}

/// Dummy [ImageProvider] used by [_NotSetImage].
class _NotSetImageProvider extends ImageProvider<_NotSetImageProvider> {
  const _NotSetImageProvider();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Holds the particle configuration information for a [ParticleBehaviour].
class ParticleOptions {
  /// Creates a [ParticleOptions] given a set of preferred values.
  ///
  /// Default values are assigned for arguments that are omitted.
  const ParticleOptions({
    this.image,
    this.baseColor = Colors.black,
    this.randomColor = true,
    this.startGame = true,
    this.spawnMinRadius = 10.0,
    this.spawnMaxRadius = 20.0,
    this.spawnMinSpeed = 50.0,
    this.spawnMaxSpeed = 80.0,
    this.spawnOpacity = 0.0,
    this.minOpacity = 1.0,
    this.maxOpacity = 1.0,
    this.opacityChangeRate = 0.25,
    this.particleCount = 50,
  })  : assert(
          spawnMaxRadius >= spawnMinRadius,
          'spawnMaxRadius >= spawnMinRadius',
        ),
        assert(spawnMinRadius >= 1, 'spawnMinRadius >= 1.0'),
        assert(spawnMaxRadius >= 1, 'spawnMaxRadius >= 1.0'),
        assert(spawnOpacity >= 0, 'spawnOpacity >= 0.0'),
        assert(spawnOpacity <= 1, 'spawnOpacity <= 1.0'),
        assert(maxOpacity >= minOpacity, 'maxOpacity >= minOpacity'),
        assert(minOpacity >= 0, 'minOpacity >= 0.0'),
        assert(minOpacity <= 1, 'minOpacity <= 1.0'),
        assert(maxOpacity >= 0, 'maxOpacity >= 0.0'),
        assert(maxOpacity <= 1, 'maxOpacity <= 1.0'),
        assert(
          spawnMaxSpeed >= spawnMinSpeed,
          'spawnMaxSpeed >= spawnMinSpeed',
        ),
        assert(spawnMinSpeed >= 0, 'spawnMinSpeed >= 0.0'),
        assert(spawnMaxSpeed >= 0, 'spawnMaxSpeed >= 0.0'),
        assert(particleCount >= 0, 'particleCount >= 0');

  /// The image used by the particle. It is mutually exclusive with [baseColor].
  final Image? image;

  /// The color used by the particle. It is mutually exclusive with [image].
  final Color baseColor;

  /// The generate random colors used by the particles.
  final bool randomColor;

  /// Used to enable pop
  final bool startGame;

  /// The minimum radius of a spawned particle. Changing this value should cause
  /// the particles to update, in case their current radius is smaller than the
  /// new value. The concrete effects depends on the instance of
  /// [ParticleBehaviour] used.
  final double spawnMinRadius;

  /// The maximum radius of a spawned particle. Changing this value should cause
  /// the particles to update, in case their current radius is bigger than the
  /// new value. The concrete effects depends on the instance of
  /// [ParticleBehaviour] used.
  final double spawnMaxRadius;

  /// The minimum speed of a spawned particle. Changing this value should cause
  /// the particles to update, in case their current speed is smaller than the
  /// new value. The concrete effects depends on the instance of
  /// [ParticleBehaviour] used.
  final double spawnMinSpeed;

  /// The maximum speed of a spawned particle. Changing this value should cause
  /// the particles to update, in case their current speed is bigger than the
  /// new value. The concrete effects depends on the instance of
  /// [ParticleBehaviour] used.
  final double spawnMaxSpeed;

  /// The opacity of a spawned particle.
  final double spawnOpacity;

  /// The minimum opacity of a particle. It is used to compute the target
  /// opacity after spawning. Implementation may differ by [ParticleBehaviour].
  final double minOpacity;

  /// The maximum opacity of a particle. It is used to compute the target
  /// opacity after spawning. Implementation may differ by [ParticleBehaviour].
  final double maxOpacity;

  /// The opacity change rate of a particle over its lifetime.
  final double opacityChangeRate;

  /// The total count of particles that should be spawned.
  final int particleCount;

  /// Creates a copy of this [ParticleOptions] but with the given fields
  /// replaced with new values.
  ParticleOptions copyWith({
    Image? image = const _NotSetImage(),
    Color? baseColor,
    bool? randomColor,
    bool? startGame,
    double? spawnMinRadius,
    double? spawnMaxRadius,
    double? spawnMinSpeed,
    double? spawnMaxSpeed,
    double? spawnOpacity,
    double? minOpacity,
    double? maxOpacity,
    double? opacityChangeRate,
    int? particleCount,
  }) {
    return ParticleOptions(
      image: image is _NotSetImage ? this.image : image,
      baseColor: baseColor ?? this.baseColor,
      startGame: startGame ?? this.startGame,
      randomColor: randomColor ?? this.randomColor,
      spawnMinRadius: spawnMinRadius ?? this.spawnMinRadius,
      spawnMaxRadius: spawnMaxRadius ?? this.spawnMaxRadius,
      spawnMinSpeed: spawnMinSpeed ?? this.spawnMinSpeed,
      spawnMaxSpeed: spawnMaxSpeed ?? this.spawnMaxSpeed,
      spawnOpacity: spawnOpacity ?? this.spawnOpacity,
      minOpacity: minOpacity ?? this.minOpacity,
      maxOpacity: maxOpacity ?? this.maxOpacity,
      opacityChangeRate: opacityChangeRate ?? this.opacityChangeRate,
      particleCount: particleCount ?? this.particleCount,
    );
  }
}
