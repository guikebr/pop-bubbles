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
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Material(
        child: AnimatedBackground(
          behaviour: RandomParticleBehaviour(options: controller.options),
          vsync: controller,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Text(
                  '00:00:00',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * .1,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withOpacity(.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
