import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/enums/state_dialog.dart';
import '../../../../../core/languages/key_translations.dart';
import '../../../../../core/monetize/ad_banner_stance.dart';
import '../../../../../core/monetize/ad_rewarded.dart';
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

  int _level = 1;
  int _countLife = 3;
  String _title = '';
  bool _gameOver = false;
  int _countPopBubbles = 0;
  String _description = '';
  List<bool> lives = <bool>[true, true, true];

  late RandomParticleBehaviour randomParticleBehaviour;
  late ParticleOptions options;
  late Duration duration;

  List<Particle> get _particles => randomParticleBehaviour.particles!;

  @override
  void onInit() {
    super.onInit();
    AdRewarded.load();
    playLoopUseCase(params: PlayLoopParams('bubble_bath.aac'));
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
    if (options.startGame && !_gameOver) {
      duration = value;
    }
    update(<String>[idTimer]);
    return value;
  }

  String getLevel() => '${KeysTranslation.textLevel.tr} $_level';

  int enemies() => options.particleCount - (options.particleCount * .2).toInt();

  String getPoint() => '$_countPopBubbles/${enemies()}';

  String getDurationString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String _minutes = twoDigits(duration.inMinutes.remainder(60));
    final String _seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$_minutes : $_seconds';
  }

  void initGame({int level = 1}) {
    _level = level;
    _countLife = 3;
    _gameOver = false;
    _countPopBubbles = 0;
    duration = Duration.zero;
    lives = <bool>[true, true, true];
    resetParticle();
  }

  bool getGameOver() {
    _countLife--;
    lives[0] = _countLife > 0;
    lives[1] = _countLife > 1;
    lives[2] = _countLife > 2;
    _gameOver = _countLife == 0;
    update(<String>[idLife]);
    return _countLife == 0;
  }

  void updateGame(BuildContext context) {
    _level++;
    _countLife = 3;
    _countPopBubbles = 0;
    lives = <bool>[true, true, true];
    resetParticle();
    if (options.startGame) {
      playUseCase(params: PlayParams('cartoon.aac'));
      Get.rawSnackbar(
        snackStyle: SnackStyle.GROUNDED,
        duration: const Duration(seconds: 2),
        messageText: MessageText(message: getLevel()),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      );
    }
  }

  Future<StateDialog> restartGame() async {
    final StateDialog? result = await Get.dialog<StateDialog>(
      NetworkGiffyDialog(
        image: Image.asset(
          'assets/the_end.gif',
          errorBuilder: (_, Object error, StackTrace? stackTrace) => const Icon(
            CupertinoIcons.info,
          ),
          fit: BoxFit.cover,
        ),
        onNeutralButtonPressed: () => Get.back<StateDialog>(
          result: StateDialog.neutral,
        ),
        onOkButtonPressed: () => Get.back<StateDialog>(
          result: StateDialog.confirm,
        ),
        onCancelButtonPressed: () => Get.back<StateDialog>(
          result: StateDialog.close,
        ),
        buttonNeutralText:
            AdRewarded.hasRewardedAd ? KeysTranslation.buttonNeutral.tr : '',
        buttonOkText: KeysTranslation.buttonReset.tr,
        buttonCancelText: KeysTranslation.buttonCancel.tr,
        title: title.Title(label: _title),
        description: Description(label: _description),
      ),
      barrierDismissible: false,
    );
    return result ?? StateDialog.close;
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
    if (_gameOver) {
      return;
    }
    final List<bool> endGame = _particles
        .where((Particle element) => !element.enemy)
        .map<bool>((Particle particle) => particle.popping && !particle.enemy)
        .toList();

    if (_countPopBubbles == endGame.length) {
      updateGame(context);
    }
  }

  void _popParticle(Particle particle) {
    if (particle.enemy) {
      if (getGameOver()) {
        playLoopUseCase.pause();
        playUseCase(params: PlayParams('danzon_da_pasion.aac'));
        _title = '${KeysTranslation.textLevel.tr} $_level';
        _description = '${KeysTranslation.textPoint.tr} $_countPopBubbles\n'
            '${KeysTranslation.textTimer.tr} ${getDurationString()}';
        resetParticle(startGame: false, randomColor: false, gameOver: true);
        restartGame().then(
          (StateDialog value) async {
            switch (value) {
              case StateDialog.close:
                Get.back<void>();
                break;
              case StateDialog.confirm:
                resetGame();
                break;
              case StateDialog.neutral:
                if (AdRewarded.hasRewardedAd) {
                  AdRewarded.rewarded(() => initGame(level: _level));
                } else {
                  resetGame();
                }
                break;
            }
          },
        );
      } else {
        playUseCase(params: PlayParams('stomach_thumps.aac'));
      }
    } else {
      if (!particle.popping) {
        playUseCase(params: PlayParams('pop.aac'));
        particle
          ..popping = true
          ..radius = 0.2 * particle.targetAlpha
          ..targetAlpha *= 0.5;
        _countPopBubbles++;
        update(<String>[idPoint]);
      }
    }
  }

  void resetGame() {
    initGame();
    playLoopUseCase.resume();
    AdRewarded.load();
    if (options.startGame && Get.context != null) {
      Get.rawSnackbar(
        snackStyle: SnackStyle.GROUNDED,
        duration: const Duration(seconds: 2),
        messageText: MessageText(message: getLevel()),
        backgroundColor: Theme.of(
          Get.context!,
        ).colorScheme.onPrimary,
      );
    }
  }

  void resetParticle({
    bool startGame = true,
    bool randomColor = true,
    bool gameOver = false,
  }) {
    options = ParticleOptions(particleCount: 10 * _level);
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
