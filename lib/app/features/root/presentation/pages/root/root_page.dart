import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/languages/key_translations.dart';
import '../../../../home/domain/repositories/animated_background.dart';
import 'root_controller.dart';
import 'widgets/animated_button.dart';

class RootPage extends GetView<RootController> {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        child: Material(
          color: Theme.of(context).colorScheme.background,
          child: AnimatedBackground(
            behaviour: RandomParticleBehaviour(options: controller.options),
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
