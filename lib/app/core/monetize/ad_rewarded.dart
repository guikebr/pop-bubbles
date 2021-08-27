import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/flavors.dart';

class AdRewarded {
  const AdRewarded._();

  static RewardedAd? _rewardedAd;

  static bool get hasRewardedAd => _rewardedAd != null;

  static String get _unitIdPROD {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2582031359836044/9110570931';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2582031359836044/4218364574';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static Future<void> load() async {
    await RewardedAd.load(
      adUnitId: F.flavor == Flavor.dev ? RewardedAd.testAdUnitId : _unitIdPROD,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) => _rewardedAd = ad,
        onAdFailedToLoad: (LoadAdError error) => _rewardedAd = null,
      ),
    );
    _rewardedAd?.fullScreenContentCallback =
        FullScreenContentCallback<RewardedAd>(
      onAdDismissedFullScreenContent: (RewardedAd ad) => ad.dispose(),
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) =>
          ad.dispose(),
    );
  }

  static void rewarded(VoidCallback receiveReward) {
    _rewardedAd?.setImmersiveMode(true);
    _rewardedAd?.show(
      onUserEarnedReward: (RewardedAd ad, RewardItem reward) => receiveReward(),
    );
    _rewardedAd = null;
  }
}
