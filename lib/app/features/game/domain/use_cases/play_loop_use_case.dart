import 'package:audioplayers/audioplayers.dart';

import '../../../../core/utils/use_case.dart';
import '../repositories/play_repository.dart';

class PlayLoopUseCase implements UseCase<AudioPlayer, PlayParams> {
  PlayLoopUseCase(this.playRepository);

  final PlayRepository playRepository;

  late AudioPlayer controller;

  @override
  Future<AudioPlayer> call({required PlayParams params}) async {
    final Future<AudioPlayer> play = playRepository.loop(path: params.path);
    controller = await play;
    return play;
  }

  @override
  Future<void> dispose() async => controller.dispose();
}

class PlayParams {
  PlayParams(this.path);

  final String path;
}
