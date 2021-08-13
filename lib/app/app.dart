import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/languages/translation_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/utils/flavors.dart';
import 'core/utils/logger.dart';
import 'themes/dark.dart';
import 'themes/light.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        theme: light,
        darkTheme: dark,
        navigatorKey: Get.key,
        themeMode: ThemeMode.dark,
        getPages: AppPages.routes,
        initialRoute: AppPages.initial,
        unknownRoute: AppPages.unknown,
        logWriterCallback: Logger.write,
        enableLog: F.flavor == Flavor.dev,
        popGesture: Get.isPopGestureEnable,
        defaultTransition: Transition.fadeIn,
        locale: TranslationController.locale,
        translations: TranslationController(),
        opaqueRoute: Get.isOpaqueRouteDefault,
        transitionDuration: Get.defaultTransitionDuration,
        debugShowCheckedModeBanner: F.flavor == Flavor.dev,
        fallbackLocale: TranslationController.fallbackLocale,
      );
}
