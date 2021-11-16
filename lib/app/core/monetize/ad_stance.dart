import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdStance {
  static void initialization() {
    WidgetsFlutterBinding.ensureInitialized();
    if (MobileAds.instance == null) {
      //MobileAds.instance.initialize();
    }
  }
}
