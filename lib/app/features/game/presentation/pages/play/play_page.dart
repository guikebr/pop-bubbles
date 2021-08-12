import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../home/domain/repositories/animated_background.dart';
import 'play_controller.dart';

class PlayPage extends GetView<PlayController> {
  const PlayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).cardColor,
      child: AnimatedBackground(
        behaviour: RandomParticleBehaviour(options: controller.options),
        vsync: controller,
        child: Container(),
      ),
    );
  }
}
