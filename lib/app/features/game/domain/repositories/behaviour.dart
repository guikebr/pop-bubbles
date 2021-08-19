import 'package:flutter/material.dart';

import 'animated_background.dart';
import 'render_animated_background.dart';

/// Base class for behaviours provided to [AnimatedBackground]
///
/// Implementing this class allows to render new types of backgrounds.
abstract class Behaviour {
  /// The render object of the [AnimatedBackground] this behaviour
  /// is provided to.
  RenderAnimatedBackground? renderObject;

  /// The size of the render object of the [AnimatedBackground]
  /// this behaviour is provided to.
  @protected
  Size? get size => renderObject?.size;

  /// Gets the initialization state of this behaviour
  bool get isInitialized;

  /// Gets the start game state of this behaviour
  bool get gameOver;

  /// Called when this behaviour should be initialized
  ///
  /// After calling this method any call to [isInitialized] should return true.
  void init();

  /// Called when this behaviour should be initialized from an old behaviour.
  void initFrom(Behaviour oldBehaviour);

  /// Called each time there is an update from the ticker
  /// on the [AnimatedBackground]
  ///
  /// The implementation must return true if there is a need to repaint and
  /// false otherwise.
  bool tick(double delta, Duration elapsed, Duration timer);

  /// Called each time the [AnimatedBackground] needs to repaint.
  ///
  /// The canvas provided in the context is already offset by the amount
  /// specified in [offset], however the parameter is provided to make the
  /// signature of the methods uniform.
  void paint(PaintingContext context, Offset offset);

  /// Called when the layout needs to be rebuilt.
  ///
  /// Allows the behaviour to include new widgets between the background and
  /// the provided child. (ie. include a [GestureDetector] to make the
  /// background interactive.
  @mustCallSuper
  Widget builder(
    BuildContext context,
    BoxConstraints constraints,
    Widget child,
  ) =>
      child;
}
