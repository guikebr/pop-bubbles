import 'package:google_mobile_ads/google_mobile_ads.dart';

class Initialization {
  static void start() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }
}
