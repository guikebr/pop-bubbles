import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/languages/key_translations.dart';
import '../../../domain/repositories/random_particle_behaviour.dart';
import '../../../infra/models/particle.dart';
import '../../../infra/models/particle_options.dart';
import '../widgets/description.dart';
import '../widgets/message_text.dart';
import '../widgets/network_gif_dialog.dart';
import '../widgets/title.dart' as title;

class PlayController extends GetxController with SingleGetTickerProviderMixin {
  String idLife = 'id_life';
  String idTimer = 'id_timer';
  String idPoint = 'id_point';
  String idLevel = 'id_level';
  String idGame = 'id_game';

  late RandomParticleBehaviour randomParticleBehaviour;

  int level = 1;
  int countLife = 3;
  int countPopBubbles = 0;
  List<bool> lives = <bool>[true, true, true];

  bool gameOver = false;

  Duration _duration = Duration.zero;

  ParticleOptions? _options;

  ParticleOptions get options => _options!;

  String _title = '';
  String _description = '';

  set options(ParticleOptions value) {
    if (value == _options) {
      return;
    }
    _options = value;
  }

  @override
  void onInit() {
    super.onInit();
    options = const ParticleOptions(opacityChangeRate: 1, particleCount: 10);
    initGame();
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

  @override
  void onClose() {
    super.onClose();
    dispose();
  }

  String getLevel() => '${KeysTranslation.textLevel.tr} $level';

  int enemies() => options.particleCount - (options.particleCount * .2).toInt();

  String getPoint() => '$countPopBubbles/${enemies()}';

  Duration getDurationTimer(Duration duration) {
    if (options.startGame) {
      _duration = duration;
      update(<String>[idTimer]);
    }
    return duration;
  }

  String getDurationString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String _minutes = twoDigits(_duration.inMinutes.remainder(60));
    final String _seconds = twoDigits(_duration.inSeconds.remainder(60));
    return '$_minutes : $_seconds';
  }

  void initGame() {
    randomParticleBehaviour = RandomParticleBehaviour(
      options: options,
      onTap: _onTap,
      duration: getDurationTimer,
    );
    level = 1;
    countLife = 3;
    gameOver = false;
    countPopBubbles = 0;
    lives = <bool>[true, true, true];
    update(<String>[idLife, idPoint, idGame]);
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
    ++level;
    countLife = 3;
    countPopBubbles = 0;
    lives = <bool>[true, true, true];
    options = options.copyWith(particleCount: 10 * level);
    if (randomParticleBehaviour.isInitialized) {
      for (final Particle p in randomParticleBehaviour.particles!) {
        p.popping = false;
      }
    }
    randomParticleBehaviour = RandomParticleBehaviour(
      options: options,
      onTap: _onTap,
      duration: getDurationTimer,
    );
    update(<String>[idLife, idPoint, idGame]);
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
    if (!options.startGame && !randomParticleBehaviour.isInitialized) {
      return;
    }
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final Offset localPosition = renderBox.globalToLocal(globalPosition);
      for (final Particle particle in randomParticleBehaviour.particles!) {
        if (!particle.popping &&
            ((Offset(particle.cx, particle.cy) - localPosition)
                    .distanceSquared <
                particle.radius * particle.radius * 1.2)) {
          _popParticle(context, particle);
        }
      }
    }
  }

  void _popParticle(BuildContext context, Particle particle) {
    if (particle.enemy) {
      if (getGameOver()) {
        _title = '${KeysTranslation.textLevel.tr} $level';
        _description = '${KeysTranslation.textPoint.tr} $countPopBubbles '
            '| ${KeysTranslation.textTimer.tr} $getDurationString()';
        options = options.copyWith(
          startGame: false,
          randomColor: false,
          particleCount: options.particleCount,
        );
        initGame();
        restartGame().then((bool value) {
          if (value) {
            final int _levelUpParticles = 10 * level;
            options = options.copyWith(
              startGame: true,
              randomColor: true,
              particleCount: _levelUpParticles,
            );
            initGame();
          }
        });
      }
    } else {
      particle
        ..popping = true
        ..radius = 0.2 * particle.targetAlpha
        ..targetAlpha *= 0.5;

      countPopParticles();
      upgradeLevel(context);
    }
  }

  void countPopParticles() {
    if (randomParticleBehaviour.particles == null) {
      return;
    }
    final List<Particle> countPopGame = randomParticleBehaviour.particles!
        .where((Particle particle) => particle.popping)
        .toList();
    countPopBubbles = countPopGame.length;
    update(<String>[idPoint]);
  }

  void upgradeLevel(BuildContext context) {
    final List<Particle> endGame = randomParticleBehaviour.particles!
        .where((Particle particle) => !particle.popping && !particle.enemy)
        .toList();
    if (endGame.isEmpty) {
      updateGame(context);
    }
  }
}
