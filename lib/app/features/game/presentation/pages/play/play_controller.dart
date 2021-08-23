import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/languages/key_translations.dart';
import '../../../../../core/monetize/ad_banner_stance.dart';
import '../../../domain/repositories/random_particle_behaviour.dart';
import '../../../domain/use_cases/play_loop_use_case.dart';
import '../../../domain/use_cases/play_use_case.dart';
import '../../../infra/models/particle.dart';
import '../../../infra/models/particle_options.dart';
import '../widgets/description.dart';
import '../widgets/message_text.dart';
import '../widgets/network_gif_dialog.dart';
import '../widgets/title.dart' as title;

class PlayController extends GetxController with SingleGetTickerProviderMixin {
  PlayController({required this.playLoopUseCase, required this.playUseCase});

  final PlayLoopUseCase playLoopUseCase;
  final PlayUseCase playUseCase;

  String idLife = 'id_life';
  String idTimer = 'id_timer';
  String idPoint = 'id_point';
  String idLevel = 'id_level';
  String idGame = 'id_game';

  int level = 1;
  int countLife = 3;
  String _title = '';
  bool gameOver = false;
  int countPopBubbles = 0;
  String _description = '';
  List<bool> lives = <bool>[true, true, true];

  late RandomParticleBehaviour randomParticleBehaviour;
  late ParticleOptions options;
  late Duration duration;
  late Timer timer;

  List<Particle> get _particles => randomParticleBehaviour.particles!;

  @override
  void onInit() {
    super.onInit();
    playLoopUseCase(params: PlayLoopParams('bubble_bath.mp3'));
    initGame();
  }

  @override
  void onClose() {
    super.onClose();
    playLoopUseCase.pause();
    playUseCase.pause();
  }

  @override
  void dispose() {
    playUseCase.dispose();
    playLoopUseCase.dispose();
    super.dispose();
  }

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

  Widget get getBanner => AdBannerStance.banner();

  Duration getDurationTimer(Duration value) {
    if (options.startGame && !gameOver) {
      duration = value;
    }
    update(<String>[idTimer]);
    return value;
  }

  String getLevel() => '${KeysTranslation.textLevel.tr} $level';

  int enemies() => options.particleCount - (options.particleCount * .2).toInt();

  String getPoint() => '$countPopBubbles/${enemies()}';

  String getDurationString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String _minutes = twoDigits(duration.inMinutes.remainder(60));
    final String _seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$_minutes : $_seconds';
  }

  void initGame() {
    level = 1;
    countLife = 3;
    gameOver = false;
    countPopBubbles = 0;
    duration = Duration.zero;
    lives = <bool>[true, true, true];
    resetParticle();
  }

  bool getGameOver() {
    countLife--;
    lives[0] = countLife > 0;
    lives[1] = countLife > 1;
    lives[2] = countLife > 2;
    gameOver = countLife == 0;
    update(<String>[idLife]);
    return countLife == 0;
  }

  void updateGame(BuildContext context) {
    level++;
    countLife = 3;
    countPopBubbles = 0;
    lives = <bool>[true, true, true];
    resetParticle();
    if (options.startGame) {
      Get.rawSnackbar(
        snackStyle: SnackStyle.GROUNDED,
        duration: const Duration(seconds: 2),
        messageText: MessageText(message: getLevel()),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      );
    }
  }

  Future<bool> restartGame() async {
    final bool? result = await Get.dialog<bool>(
      NetworkGiffyDialog(
        image: Image.asset(
          'assets/the_end.gif',
          errorBuilder: (_, Object error, StackTrace? stackTrace) => const Icon(
            CupertinoIcons.info,
          ),
          fit: BoxFit.cover,
        ),
        onOkButtonPressed: () => Get.back<bool>(result: true),
        onCancelButtonPressed: () => Get.close(2),
        buttonOkText: KeysTranslation.buttonReset.tr,
        buttonCancelText: KeysTranslation.buttonCancel.tr,
        title: title.Title(label: _title),
        description: Description(label: _description),
      ),
      barrierDismissible: false,
    );
    return result ?? false;
  }

  void _onTap(BuildContext context, Offset globalPosition) {
    if (!randomParticleBehaviour.isInitialized && !options.startGame) {
      return;
    }
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final Offset localPosition = renderBox.globalToLocal(globalPosition);
      for (final Particle particle in _particles) {
        if (!particle.popping &&
            ((Offset(particle.cx, particle.cy) - localPosition)
                    .distanceSquared <
                particle.radius * particle.radius * 1.2)) {
          _popParticle(particle);
        }
      }
      upgradeLevel(context);
    }
  }

  void upgradeLevel(BuildContext context) {
    if (gameOver) {
      return;
    }
    final List<bool> endGame = _particles
        .where((Particle element) => !element.enemy)
        .map<bool>((Particle particle) => particle.popping && !particle.enemy)
        .toList();

    if (countPopBubbles == endGame.length) {
      updateGame(context);
    }
  }

  void _popParticle(Particle particle) {
    if (particle.enemy) {
      if (getGameOver()) {
        playLoopUseCase.pause();
        playUseCase(params: PlayParams('danzon_da_pasion.mp3'));
        _title = '${KeysTranslation.textLevel.tr} $level';
        _description = '${KeysTranslation.textPoint.tr} $countPopBubbles\n'
            '${KeysTranslation.textTimer.tr} ${getDurationString()}';
        resetParticle(startGame: false, randomColor: false, gameOver: true);
        restartGame().then((bool value) async {
          if (value) {
            initGame();
            playLoopUseCase.resume();
            if (options.startGame && Get.context != null) {
              Get.rawSnackbar(
                snackStyle: SnackStyle.GROUNDED,
                duration: const Duration(seconds: 2),
                messageText: MessageText(message: getLevel()),
                backgroundColor: Theme.of(Get.context!).colorScheme.onPrimary,
              );
            }
          }
        });
      } else {
        playUseCase(params: PlayParams('stomach_thumps.mp3'));
      }
    } else {
      if (!particle.popping) {
        playUseCase(params: PlayParams('pop.mp3'));
        particle
          ..popping = true
          ..radius = 0.2 * particle.targetAlpha
          ..targetAlpha *= 0.5;
        countPopBubbles++;
        update(<String>[idPoint]);
      }
    }
  }

  void resetParticle({
    bool startGame = true,
    bool randomColor = true,
    bool gameOver = false,
  }) {
    options = ParticleOptions(particleCount: 10 * level);
    final RandomParticleBehaviour _randomParticleBehaviour =
        RandomParticleBehaviour(
      onTap: _onTap,
      duration: getDurationTimer,
      options: options.copyWith(
        startGame: startGame,
        randomColor: randomColor,
        gameOver: gameOver,
      ),
    );
    randomParticleBehaviour = _randomParticleBehaviour;
    update(<String>[idLife, idTimer, idLevel, idPoint, idGame]);
  }
}
