import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'behaviour.dart';

/// An animated background in the render tree.
class RenderAnimatedBackground extends RenderProxyBox {
  /// Creates a new render for animated background with the provided arguments.
  RenderAnimatedBackground({
    required TickerProvider vsync,
    required Behaviour behaviour,
  })  : _vsync = vsync,
        _behaviour = behaviour {
    _behaviour.renderObject = this;
  }

  int _lastTimeMs = 0;
  final TickerProvider _vsync;
  late Ticker _ticker;

  Behaviour _behaviour;

  /// Gets the behaviour used by this animated background.
  Behaviour get behaviour => _behaviour;

  /// Set the behaviour used by this animated background.
  set behaviour(Behaviour value) {
    assert(value != null, 'error value != null');
    final Behaviour oldBehaviour = _behaviour;
    _behaviour = value;
    _behaviour
      ..renderObject = this
      ..initFrom(oldBehaviour);
  }

  /// Gets the layout callback that should be called when performing layout.
  LayoutCallback<BoxConstraints> get callback => _callback!;
  LayoutCallback<BoxConstraints>? _callback;

  /// Sets the layout callback that should be called when performing layout.
  set callback(LayoutCallback<BoxConstraints>? value) {
    if (value == _callback) {
      return;
    }
    _callback = value;
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    _lastTimeMs = 0;
    _ticker = _vsync.createTicker(_tick);
    _ticker.start();
    super.attach(owner);
  }

  @override
  void detach() {
    _ticker.dispose();
    super.detach();
  }

  void _tick(Duration elapsed) {
    if (!_behaviour.isInitialized) {
      return;
    }

    final double delta = (elapsed.inMilliseconds - _lastTimeMs) / 1000.0;
    _lastTimeMs = elapsed.inMilliseconds;

    if (_behaviour.tick(delta, elapsed)) {
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    invokeLayoutCallback(callback);
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
    }
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!behaviour.isInitialized) {
      behaviour.init();
    }
    final Canvas canvas = context.canvas..translate(offset.dx, offset.dy);
    behaviour.paint(context, offset);
    canvas.translate(-offset.dx, -offset.dy);

    super.paint(context, offset);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Behaviour>('behaviour', behaviour))
      ..add(ObjectFlagProperty<LayoutCallback<BoxConstraints>>.has(
        'callback',
        callback,
      ));
  }
}
