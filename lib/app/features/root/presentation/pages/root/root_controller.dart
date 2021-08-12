import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../../../../home/infra/models/particle_options.dart';

class RootController extends GetxController with SingleGetTickerProviderMixin {
  late double scale;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
    lowerBound: 0.6,
  );

  late final Animation<double> animatedButtonController = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  final ParticleOptions options = const ParticleOptions(
    startGame: false,
    minOpacity: 0.5,
    maxOpacity: 0.8,
    particleCount: 100,
  );

  @override
  void onReady() {
    super.onReady();
    _controller.repeat(reverse: true);
  }

  @override
  void onClose() {
    super.onClose();
    _controller.dispose();
  }

  void tapDown(TapDownDetails details) {
    print('oi');
  }

  void tapUp(TapUpDetails details) {
    print('tchau');
  }
}
