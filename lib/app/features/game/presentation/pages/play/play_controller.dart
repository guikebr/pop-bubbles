import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/languages/key_translations.dart';
import '../../../../home/infra/models/particle_options.dart';
import '../widgets/message_text.dart';

class PlayController extends GetxController with SingleGetTickerProviderMixin {
  String idLife = 'id_life';
  String idTimer = 'id_timer';
  String idPoint = 'id_point';
  String idLevel = 'id_level';
  String idGame = 'id_game';

  ParticleOptions options = const ParticleOptions(
    opacityChangeRate: 1,
    particleCount: 10,
  );

  int level = 1;
  int countLife = 3;
  int countPopBubbles = 0;
  final List<bool> lives = <bool>[true, true, true];

  bool gameOver = false;

  Duration duration = Duration.zero;

  @override
  void onReady() {
    super.onReady();
    Get.rawSnackbar(
      snackStyle: SnackStyle.GROUNDED,
      duration: const Duration(seconds: 2),
      messageText: MessageText(message: getLevel()),
      backgroundColor: Theme.of(Get.overlayContext!).colorScheme.onPrimary,
    );
  }

  String getLevel() => '${KeysTranslation.textLevel.tr} $level';

  int enemies() => options.particleCount - (options.particleCount * .2).toInt();

  String getPoint() => '$countPopBubbles/${enemies()}';

  String getDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String _minutes = twoDigits(duration.inMinutes.remainder(60));
    final String _seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$_minutes : $_seconds';
  }

  void restartGame() => options = options.copyWith();

  void upgradeLevel() {
    ++level;
    countLife = 3;
    countPopBubbles = 0;
    // options = options.copyWith(
    //   startGame: true,
    //   randomColor: true,
    //   particleCount: 10 * level,
    // );
    update(<String>[idGame]);
    update(<String>[idPoint]);
    Get.rawSnackbar(
      snackStyle: SnackStyle.GROUNDED,
      duration: const Duration(seconds: 2),
      messageText: MessageText(message: getLevel()),
      backgroundColor: Theme.of(Get.overlayContext!).colorScheme.onPrimary,
    );
  }

  void enemyTap() {
    countLife--;
    lives[0] = countLife > 0;
    lives[1] = countLife > 1;
    lives[2] = countLife > 2;
    gameOver = countLife == 0;
    if (gameOver) {
      options = options.copyWith(startGame: false, randomColor: false);
      update(<String>[idGame]);
    } else {
      update(<String>[idLife]);
    }
  }
}
