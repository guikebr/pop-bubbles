import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/languages/key_translations.dart';
import '../../../../game/domain/repositories/animated_background.dart';
import '../../../../game/infra/models/particle_options.dart';
import 'root_controller.dart';
import 'widgets/animated_button.dart';

class RootPage extends GetView<RootController> {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        child: Material(
          color: Theme.of(context).colorScheme.background,
          child: AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              onTap: controller.onTap,
              duration: controller.getDurationTimer,
              options: const ParticleOptions(
                startGame: false,
                minOpacity: 0.5,
                maxOpacity: 0.8,
              ),
            ),
            vsync: controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      KeysTranslation.textWelcome.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * .2,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                      ),
                    ),
                    Text(
                      KeysTranslation.textDescription.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * .1,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
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
