import 'package:audioplayers/audioplayers.dart';

abstract class PlayRepository {
  Future<AudioPlayer> play({required String path});

  Future<AudioPlayer> loop({required String path});
}
