import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../core/routes/app_pages.dart';
import '../../../../home/infra/models/particle_options.dart';

class RootController extends GetxController with SingleGetTickerProviderMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.5,
  );

  late final Animation<double> animatedButtonController = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  final ParticleOptions options = const ParticleOptions(
    startGame: false,
    minOpacity: 0.5,
    maxOpacity: 0.8,
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

  void navigateGame() {
    Get.toNamed<void>(Routes.playPage);
  }
}
