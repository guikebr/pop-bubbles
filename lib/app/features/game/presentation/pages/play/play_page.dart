import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/monetize/ad_banner_stance.dart';
import '../../../domain/repositories/animated_background.dart';
import 'play_controller.dart';

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
              child: OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) =>
                    Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Positioned.fill(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: orientation == Orientation.portrait
                                ? MediaQuery.of(context).size.height * .1
                                : MediaQuery.of(context).size.height * .15,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimary.withOpacity(.8),
                            child: Padding(
                              padding: orientation == Orientation.portrait
                                  ? EdgeInsets.only(top: Get.size.height * .04)
                                  : EdgeInsets.zero,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: GetBuilder<PlayController>(
                                      init: get,
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
                                      init: get,
                                      id: get.idTimer,
                                      builder: (PlayController getX) => Text(
                                        getX.getDurationString(),
                                        textAlign:
                                            orientation == Orientation.portrait
                                                ? TextAlign.end
                                                : TextAlign.center,
                                        style: TextStyle(
                                          fontSize: orientation ==
                                                  Orientation.portrait
                                              ? Get.size.width * .08
                                              : Get.size.width * .05,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          )
                                              .colorScheme
                                              .onSecondary
                                              .withOpacity(.8),
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
                                          fontSize: orientation ==
                                                  Orientation.portrait
                                              ? Get.size.width * .08
                                              : Get.size.width * .05,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          )
                                              .colorScheme
                                              .onSecondary
                                              .withOpacity(.8),
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
                    AdBannerStance.banner(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
