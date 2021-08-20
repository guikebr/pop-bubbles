import 'package:audioplayers/audioplayers.dart';

import '../../domain/repositories/play_repository.dart';
import '../data/play_data.dart';

class PlayRepositoryImpl implements PlayRepository {
  PlayRepositoryImpl({required this.playData});

  final PlayData playData;

  @override
  Future<AudioPlayer> play({required String path}) async {
    return playData.play(path: path);
  }

  @override
  Future<AudioPlayer> loop({required String path}) async {
    return playData.loop(path: path);
  }
}
