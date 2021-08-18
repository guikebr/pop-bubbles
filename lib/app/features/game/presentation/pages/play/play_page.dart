import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/repositories/animated_background.dart';
import 'play_controller.dart';

class PlayGame extends GetxController with SingleGetTickerProviderMixin {}

class PlayPage extends GetView<PlayController> {
  const PlayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Material(
          child: GetBuilder<PlayController>(
            init: controller,
            id: controller.idGame,
            builder: (PlayController get) => AnimatedBackground(
              behaviour: get.randomParticleBehaviour,
              vsync: get,
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withOpacity(.8),
                    child: Padding(
                      padding: EdgeInsets.only(top: Get.size.height * .04),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GetBuilder<PlayController>(
                              id: get.idLife,
                              builder: (PlayController getX) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: getX.lives
                                    .map((bool e) => Image.asset(e
                                        ? 'assets/heart_fill.png'
                                        : 'assets/heart_stroke.png'))
                                    .toList(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GetBuilder<PlayController>(
                              id: get.idTimer,
                              builder: (PlayController getX) => Text(
                                get.getDurationString(),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: Get.size.width * .08,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary.withOpacity(.8),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GetBuilder<PlayController>(
                              init: get,
                              id: get.idPoint,
                              builder: (PlayController getX) => Text(
                                getX.getPoint(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Get.size.width * .08,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary.withOpacity(.8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
