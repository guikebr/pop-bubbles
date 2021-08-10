import 'package:get/get.dart';

import '../../../../home/presentatiom/pages/home/home_controller.dart';
import 'root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() => Get
    ..lazyPut<RootController>(() => RootController())
    ..lazyPut<HomeController>(() => HomeController());
}
