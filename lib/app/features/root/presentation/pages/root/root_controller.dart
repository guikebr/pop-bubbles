import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../core/routes/app_pages.dart';

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

  Duration getDurationTimer(Duration duration) => duration;

  void onTap(BuildContext context, Offset globalPosition) {}

  void navigateGame() => Get.toNamed<void>(Routes.playPage);
}
