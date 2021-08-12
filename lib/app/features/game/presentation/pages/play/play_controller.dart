import 'package:get/get.dart';
import '../../../../home/infra/models/particle_options.dart';

class PlayController extends GetxController with SingleGetTickerProviderMixin {
  final ParticleOptions options = const ParticleOptions(opacityChangeRate: 1);
}
