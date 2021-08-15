import 'package:get/get.dart';
import '../../../../home/infra/models/particle_options.dart';

class PlayController extends GetxController with SingleGetTickerProviderMixin {
  String idLife = 'id_life';
  String idTimer = 'id_Timer';
  String idGame = 'id_game';

  ParticleOptions options = const ParticleOptions(opacityChangeRate: 1);
  int countLife = 3;
  final List<bool> lives = <bool>[true, true, true];

  bool gameOver = false;

  Duration duration = Duration.zero;

  String getDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String _minutes = twoDigits(duration.inMinutes.remainder(60));
    final String _seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$_minutes : $_seconds';
  }

  void restartGame() => options = options.copyWith();

  void enemyTap() {
    countLife--;
    lives[0] = countLife > 0;
    lives[1] = countLife > 1;
    lives[2] = countLife > 2;
    gameOver = countLife == 0;
    if (!gameOver) {
      update(<String>[idLife]);
    } else {
      options = options.copyWith(startGame: false, randomColor: false);
      update(<String>[idGame]);
    }
  }
}
