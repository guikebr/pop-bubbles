import 'package:audioplayers/audioplayers.dart';

import '../../../../core/utils/use_case.dart';
import '../repositories/play_repository.dart';

class PlayLoopUseCase implements UseCase<AudioPlayer, PlayLoopParams> {
  PlayLoopUseCase(this.playRepository);

  final PlayRepository playRepository;

  late AudioPlayer controller;

  @override
  Future<AudioPlayer> call({required PlayLoopParams params}) async {
    final Future<AudioPlayer> play = playRepository.loop(path: params.path);
    controller = await play;
    return play;
  }

  @override
  void stop() => controller.stop();
}

class PlayLoopParams {
  PlayLoopParams(this.path);

  final String path;
}
