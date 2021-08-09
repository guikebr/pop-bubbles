import 'package:get/get.dart';
import '../../features/home/presentatiom/pages/home_binding.dart';
import '../../features/home/presentatiom/pages/home_page.dart';
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
    unknown,
    GetPage<HomePage>(
      name: Routes.homePage,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
