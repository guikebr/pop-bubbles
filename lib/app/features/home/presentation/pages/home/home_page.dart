import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/repositories/animated_background.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: AnimatedBackground(
        behaviour: RandomParticleBehaviour(),
        vsync: controller,
        child: Container(),
      ),
    );
  }
}
