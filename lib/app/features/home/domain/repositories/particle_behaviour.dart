import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

import '../../../../core/helpers/image_helper.dart';
import '../../infra/models/particle.dart';
import '../../infra/models/particle_options.dart';
import 'animated_background.dart';
import 'behaviour.dart';

/// The base for behaviours that render particles on an [AnimatedBackground].
abstract class ParticleBehaviour extends Behaviour {
  /// Creates a new particle behaviour.
  ///
  /// Default values will be assigned to the parameters if not specified.
  ParticleBehaviour({
    ParticleOptions options = const ParticleOptions(),
    Paint? paint,
  }) {
    _options = options;
    particlePaint = paint;
    if (options.image != null) {
      _convertImage(options.image!);
    }
  }

  /// The list of particles used by the particle
  /// behaviour to hold the spawned particles.
  @protected
  List<Particle>? particles;

  @override
  bool get isInitialized => particles != null;

  Rect? _particleImageSrc;
  ui.Image? _particleImage;
  VoidCallback? _pendingConversion;

  Paint? _paint;

  Paint? get particlePaint => _paint;

  set particlePaint(Paint? value) {
    if (value == null) {
      _paint = Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill
        ..strokeWidth = 1.0;
    } else {
      _paint = value;
    }

    if (_paint!.strokeWidth <= 0) {
      _paint!.strokeWidth = 1.0;
    }
  }

  ParticleOptions? _options;

  /// Gets the particle options used to configure this behaviour.
  ParticleOptions get options => _options!;

  /// Set the particle options used to configure this behaviour.
  ///
  /// Changing this value will cause the currently spawned particles to update.
  set options(ParticleOptions value) {
    if (value == _options) {
      return;
    }
    final ParticleOptions? oldOptions = _options;
    _options = value;

    if (_options!.image == null) {
      _particleImage = null;
    } else if (_particleImage == null || oldOptions!.image != _options!.image) {
      _convertImage(_options!.image!);
    }

    onOptionsUpdate(oldOptions);
  }

  @override
  void init() => particles = generateParticles(options.particleCount);

  @override
  void initFrom(Behaviour oldBehaviour) {
    if (oldBehaviour is ParticleBehaviour) {
      particles = oldBehaviour.particles;

      // keep old image if waiting for a new one
      if (options.image != null && _particleImage == null) {
        _particleImage = oldBehaviour._particleImage;
        _particleImageSrc = oldBehaviour._particleImageSrc;
      }

      onOptionsUpdate(oldBehaviour.options);
    }
  }

  @override
  bool tick(double delta, Duration elapsed) {
    if (!isInitialized) {
      return false;
    }

    for (final Particle particle in particles!) {
      if (!size!.contains(Offset(particle.cx, particle.cy))) {
        initParticle(particle);
        continue;
      }

      updateParticle(particle, delta, elapsed);
    }
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    for (final Particle particle in particles!) {
      if (particle.alpha == 0.0 || particle.popping) {
        continue;
      }
      if (options.randomColor) {
        _paint!.color = particle.color.withOpacity(particle.alpha);
      } else {
        _paint!.color = options.baseColor.withOpacity(particle.alpha);
      }

      _paint!.style =
          particle.enemy ? PaintingStyle.stroke : PaintingStyle.fill;

      if (_particleImage != null) {
        final Rect dst = Rect.fromLTRB(
          particle.cx - particle.radius,
          particle.cy - particle.radius,
          particle.cx + particle.radius,
          particle.cy + particle.radius,
        );
        canvas.drawImageRect(_particleImage!, _particleImageSrc!, dst, _paint!);
      } else {
        canvas.drawCircle(
          Offset(particle.cx, particle.cy),
          particle.radius,
          _paint!,
        );
      }
    }
  }

  /// Generates an amount of particles and initializes them.
  ///
  /// This can be used to generate the initial particles or new particles when
  /// the options change
  @protected
  List<Particle> generateParticles(int numParticles) {
    return List<int>.generate(numParticles, (int i) => i).map((int i) {
      final Particle p = Particle();
      if (options.randomColor) {
        p
          ..color = randomColor()
          ..popping = false
          ..enemy = randomInt() > i && options.startGame;
      } else {
        p
          ..popping = false
          ..enemy = false
          ..enemy = randomInt() > i && options.startGame;
      }
      initParticle(p);
      return p;
    }).toList();
  }

  @protected
  void initParticle(Particle particle);

  @protected
  void updateParticle(Particle particle, double delta, Duration elapsed) {
    particle
      ..cx += particle.dx * delta
      ..cy += particle.dy * delta;
    if (options.opacityChangeRate > 0 &&
            particle.alpha < particle.targetAlpha ||
        options.opacityChangeRate < 0 &&
            particle.alpha > particle.targetAlpha) {
      particle.alpha = particle.alpha + delta * options.opacityChangeRate;

      if (options.opacityChangeRate > 0 &&
              particle.alpha > particle.targetAlpha ||
          options.opacityChangeRate < 0 &&
              particle.alpha < particle.targetAlpha) {
        particle.alpha = particle.targetAlpha;
      }
    }
  }

  @protected
  @mustCallSuper
  void onOptionsUpdate(ParticleOptions? oldOptions) {
    if (particles == null) {
      return;
    }
    if (particles!.length > options.particleCount) {
      particles!.removeRange(0, particles!.length - options.particleCount);
    } else if (particles!.length < options.particleCount) {
      final int particlesToSpawn = options.particleCount - particles!.length;
      final List<Particle> newParticles = generateParticles(particlesToSpawn);
      particles!.addAll(newParticles);
    }
  }

  /// Generate int Random
  int randomInt() => Random().nextInt(20);

  /// Generates random color to be used by the rectangles
  static Color randomColor() {
    return (<Color>[...material.Colors.primaries]..shuffle()).first;
  }

  void _convertImage(Image image) {
    if (_pendingConversion != null) {
      _pendingConversion!();
    }
    _pendingConversion = convertImage(image, (ui.Image outImage) {
      _pendingConversion = null;
      _particleImageSrc = Rect.fromLTRB(
        0,
        0,
        outImage.width.toDouble(),
        outImage.height.toDouble(),
      );
      _particleImage = outImage;
    });
  }

  @override
  Widget builder(
    BuildContext context,
    BoxConstraints constraints,
    Widget child,
  ) =>
      GestureDetector(
        behavior: material.HitTestBehavior.translucent,
        onTapDown: (TapDownDetails details) => _onTap(
          context,
          details.globalPosition,
        ),
        child: ConstrainedBox(
          // necessary to force gesture detector to cover screen
          constraints: const BoxConstraints(
            minHeight: double.infinity,
            minWidth: double.infinity,
          ),
          child: super.builder(context, constraints, child),
        ),
      );

  void _onTap(BuildContext context, Offset globalPosition) {
    if (!options.startGame) {
      options = options.copyWith(randomColor: false);
      return;
    }
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final Offset localPosition = renderBox.globalToLocal(globalPosition);
      for (final Particle particle in particles!) {
        if ((Offset(particle.cx, particle.cy) - localPosition).distanceSquared <
            particle.radius * particle.radius * 1.2) {
          _popParticle(particle);
          print(particle.color);
        }
      }
    }
  }

  void _popParticle(Particle particle) {
    particle
      ..popping = true
      ..radius = 0.2 * particle.targetAlpha
      ..targetAlpha *= 0.5;
  }
}
