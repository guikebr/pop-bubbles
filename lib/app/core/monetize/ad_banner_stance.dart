import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/flavors.dart';

class AdBannerStance {
  const AdBannerStance._();

  static String get _unitIdPROD {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2582031359836044/5267512935';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2582031359836044/7494221029';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static Widget banner() {
    final BannerAd _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: F.flavor == Flavor.dev ? BannerAd.testAdUnitId : _unitIdPROD,
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) => ad.dispose(),
      ),
      request: const AdRequest(),
    );

    final BannerAd load = _bannerAd..load();

    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxHeight: _bannerAd.size.height.toDouble(),
        minHeight: _bannerAd.size.height.toDouble(),
        maxWidth: _bannerAd.size.width.toDouble(),
        minWidth: _bannerAd.size.width.toDouble(),
      ),
      child: AdWidget(key: UniqueKey(), ad: load),
    );
  }
}
