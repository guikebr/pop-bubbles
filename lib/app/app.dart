import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/languages/translation_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/utils/flavors.dart';
import 'core/utils/logger.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        navigatorKey: Get.key,
        themeMode: ThemeMode.dark,
        initialRoute: AppPages.initial,
        unknownRoute: AppPages.unknown,
        logWriterCallback: Logger.write,
        enableLog: F.flavor == Flavor.dev,
        popGesture: Get.isPopGestureEnable,
        locale: TranslationController.locale,
        translations: TranslationController(),
        opaqueRoute: Get.isOpaqueRouteDefault,
        defaultTransition: Transition.cupertino,
        transitionDuration: Get.defaultTransitionDuration,
        debugShowCheckedModeBanner: F.flavor == Flavor.dev,
        fallbackLocale: TranslationController.fallbackLocale,
      );
}
