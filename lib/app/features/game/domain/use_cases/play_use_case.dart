import 'package:audioplayers/audioplayers.dart';

import '../../../../core/utils/use_case.dart';
import '../repositories/play_repository.dart';

class PlayUseCase implements UseCase<AudioPlayer, PlayParams> {
  PlayUseCase(this.playRepository);

  final PlayRepository playRepository;

  @override
  Future<AudioPlayer> call({required PlayParams params}) {
    return playRepository.play(path: params.path);
  }
}

class PlayParams {
  PlayParams(this.path);

  final String path;
}
