import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdStance {
  static void initialization() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }
}
