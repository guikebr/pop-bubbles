import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../home/domain/repositories/animated_background.dart';
import 'root_controller.dart';
import 'widgets/animated_button.dart';

class RootPage extends GetView<RootController> {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        child: Material(
          child: AnimatedBackground(
            behaviour: RandomParticleBehaviour(options: controller.options),
            vsync: controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: const <Widget>[
                    Text(
                      'BEM VINDO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 40,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'THE POP BUBBLES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GetBuilder<RootController>(
                  init: controller,
                  builder: (RootController get) => GestureDetector(
                    onTap: get.navigateGame,
                    child: ScaleTransition(
                      scale: get.animatedButtonController,
                      child: const AnimatedButton(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
