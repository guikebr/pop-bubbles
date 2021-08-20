import 'package:audioplayers/audioplayers.dart';

abstract class PlayData {
  Future<AudioPlayer> play({required String path});

  Future<AudioPlayer> loop({required String path});
}
