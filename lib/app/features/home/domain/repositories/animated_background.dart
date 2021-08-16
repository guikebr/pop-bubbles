import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'behaviour.dart';
import 'render_animated_background.dart';

export 'random_particle_behaviour.dart';

/// A widget that renders an animated background.
class AnimatedBackground extends RenderObjectWidget {
  /// Creates a new animated background with the provided arguments
  const AnimatedBackground({
    required this.child,
    required this.vsync,
    required this.behaviour,
    Key? key,
  }) : super(key: key);

  /// The child widget that is rendered on top of the background
  final Widget child;

  /// The ticker provider that provides the tick to update the background
  final TickerProvider vsync;

  /// The behaviour used to render the particles
  final Behaviour behaviour;

  @override
  RenderAnimatedBackground createRenderObject(BuildContext context) =>
      RenderAnimatedBackground(
        vsync: vsync,
        behaviour: behaviour,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderAnimatedBackground renderObject,
  ) =>
      renderObject.behaviour = behaviour;

  @override
  _AnimatedBackgroundElement createElement() =>
      _AnimatedBackgroundElement(this);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TickerProvider>('vsync', vsync))
      ..add(DiagnosticsProperty<Behaviour>('behaviour', behaviour));
  }
}

class _AnimatedBackgroundElement extends RenderObjectElement {
  _AnimatedBackgroundElement(AnimatedBackground widget) : super(widget);

  @override
  AnimatedBackground get widget => super.widget as AnimatedBackground;

  @override
  RenderAnimatedBackground get renderObject =>
      super.renderObject as RenderAnimatedBackground;

  Element? _child;

  @override
  void forgetChild(Element child) {
    super.forgetChild(child);
    assert(child == _child, 'error child == _child');
    _child = null;
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    final RenderObjectWithChildMixin<RenderObject> renderObject =
        this.renderObject;
    assert(slot == null, 'error slot == null');
    assert(renderObject.debugValidateChild(child), 'error renderObject');
    renderObject.child = child;
    assert(
      renderObject == this.renderObject,
      'error renderObject == this.renderObject',
    );
  }

  @override
  void moveRenderObjectChild(
    RenderObject child,
    Object? oldSlot,
    Object? newSlot,
  ) {
    assert(false, 'error');
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    final RenderAnimatedBackground renderObject = this.renderObject;
    assert(renderObject.child == child, 'error renderObject.child == child');
    renderObject.child = null;
    assert(
      renderObject == this.renderObject,
      'error renderObject == this.renderObject',
    );
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_child != null) {
      visitor(_child!);
    }
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    renderObject.callback = _layoutCallback;
  }

  @override
  void update(AnimatedBackground newWidget) {
    assert(widget != newWidget, 'error widget != newWidget');
    super.update(newWidget);
    assert(widget == newWidget, 'error widget == newWidget');
    renderObject
      ..callback = _layoutCallback
      ..markNeedsLayout();
  }

  @override
  void performRebuild() {
    renderObject.markNeedsLayout();
    super.performRebuild();
  }

  @override
  void unmount() {
    renderObject.callback = null;
    super.unmount();
  }

  void _layoutCallback(BoxConstraints constraints) {
    owner!.buildScope(this, () {
      Widget built;
      try {
        built = widget.behaviour.builder(this, constraints, widget.child);
        debugWidgetBuilderValue(widget, built);
      } on Exception catch (e, stack) {
        built = ErrorWidget.builder(_debugReportException(
          'building $widget',
          e,
          stack,
        ));
      }

      try {
        _child = updateChild(_child, built, null);
        assert(_child != null, 'error _child != null');
      } on Exception catch (e, stack) {
        built = ErrorWidget.builder(_debugReportException(
          'building $widget',
          e,
          stack,
        ));
        _child = updateChild(null, built, slot);
      }
    });
  }

  final bool _useDiagnosticsNode = FlutterError('text') is Diagnosticable;

  dynamic _safeContext(String context) =>
      _useDiagnosticsNode ? DiagnosticsNode.message(context) : context;

  FlutterErrorDetails _debugReportException(
    String context,
    Object exception,
    StackTrace stack,
  ) {
    final FlutterErrorDetails details = FlutterErrorDetails(
      exception: exception,
      stack: stack,
      library: 'animated background library',
      context: _safeContext(context) as DiagnosticsNode,
    );

    FlutterError.reportError(details);
    return details;
  }
}
