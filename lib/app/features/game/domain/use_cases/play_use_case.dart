import 'package:audioplayers/audioplayers.dart';

import '../../../../core/utils/use_case.dart';
import '../repositories/play_repository.dart';

class PlayUseCase implements UseCase<AudioPlayer, PlayParams> {
  PlayUseCase(this.playRepository);

  final PlayRepository playRepository;

  late AudioPlayer controller;

  @override
  Future<AudioPlayer> call({required PlayParams params}) async {
    final Future<AudioPlayer> play = playRepository.play(path: params.path);
    controller = await play;
    return play;
  }

  @override
  void stop() => controller.stop();
}

class PlayParams {
  PlayParams(this.path);

  final String path;
}
