import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../../../domain/use_cases/play_loop_use_case.dart';
import '../../../domain/use_cases/play_use_case.dart';
import '../../../external/data/play_data_impl.dart';
import '../../../infra/repositories/play_repository_impl.dart';
import 'play_controller.dart';

class PlayBinding extends Bindings {
  final PlayRepositoryImpl repository = PlayRepositoryImpl(
    playData: PlayDataImpl(audioCache: AudioCache()),
  );

  @override
  void dependencies() => Get.lazyPut<PlayController>(
        () => PlayController(
          playLoopUseCase: PlayLoopUseCase(repository),
          playUseCase: PlayUseCase(repository),
        ),
      );
}
