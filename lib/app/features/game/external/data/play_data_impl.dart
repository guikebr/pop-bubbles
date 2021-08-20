import 'package:audioplayers/audioplayers.dart';

import '../../infra/data/play_data.dart';

class PlayDataImpl implements PlayData {
  PlayDataImpl({required this.audioCache});

  final AudioCache audioCache;

  @override
  Future<AudioPlayer> loop({required String path}) async {
    return audioCache.loop(path);
  }

  @override
  Future<AudioPlayer> play({required String path}) async {
    return audioCache.play(path);
  }
}
