import 'package:get/get.dart';
import '../../features/game/presentation/pages/play/play_binding.dart';
import '../../features/game/presentation/pages/play/play_page.dart';
import '../../features/home/presentation/pages/home/home_binding.dart';
import '../../features/home/presentation/pages/home/home_page.dart';
import '../../features/root/presentation/pages/root/root_binding.dart';
import '../../features/root/presentation/pages/root/root_page.dart';
import '../../features/unknown/presentation/pages/unknown_page.dart';

part 'app_routes.dart';

abstract class AppPages {
  const AppPages._();

  static const String initial = Routes.rootPage;

  static GetPage<UnknownPage> unknown = GetPage<UnknownPage>(
    name: Routes.unknownPage,
    page: () => const UnknownPage(),
  );

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<RootPage>(
      name: Routes.rootPage,
      page: () => const RootPage(),
      bindings: <Bindings>[RootBinding(), PlayBinding()],
    ),
    unknown,
    GetPage<HomePage>(
      name: Routes.homePage,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage<PlayPage>(
      name: Routes.playPage,
      page: () => const PlayPage(),
      binding: PlayBinding(),
    ),
  ];
}
