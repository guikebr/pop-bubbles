import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/flavors.dart';

class AdBannerStance {
  const AdBannerStance._();

  static late final BannerAd _bannerAd;

  static String get _unitIdPROD {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2582031359836044/5267512935';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2582031359836044/7494221029';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get _unitIdDEV {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static void dispose() => _bannerAd.dispose();

  static Widget banner() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: F.flavor == Flavor.dev ? _unitIdDEV : _unitIdPROD,
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) => ad.dispose(),
      ),
      request: const AdRequest(),
    )..load();

    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxHeight: _bannerAd.size.height.toDouble(),
        minHeight: _bannerAd.size.height.toDouble(),
        maxWidth: _bannerAd.size.width.toDouble(),
        minWidth: _bannerAd.size.width.toDouble(),
      ),
      child: AdWidget(key: UniqueKey(), ad: _bannerAd),
    );
  }
}

/*
Android
Testar os IDs da AdMob para Android:

Item

ID do app/ID do bloco de anúncios

ID do app da AdMob

ca-app-pub-3940256099942544~4354546703

Banner

ca-app-pub-3940256099942544/8865242552

Intersticial

ca-app-pub-3940256099942544/7049598008

Premiado

ca-app-pub-3940256099942544/8673189370

No iOS
Testar os IDs da AdMob para iOS:

Item

ID do app/ID do bloco de anúncios

ID do app da AdMob

ca-app-pub-3940256099942544~2594085930

Banner

ca-app-pub-3940256099942544/4339318960

Intersticial

ca-app-pub-3940256099942544/3964253750

Premiado

ca-app-pub-3940256099942544/7552160883

* */
