import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/flavors.dart';

class AdRewarded {
  const AdRewarded._();

  static RewardedAd? _rewardedAd;

  static String get _unitIdPROD {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2582031359836044/9110570931';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2582031359836044/4218364574';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static void rewarded() {
    RewardedAd.load(
      adUnitId: F.flavor == Flavor.dev ? RewardedAd.testAdUnitId : _unitIdPROD,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );

    if (_rewardedAd == null) {
      return;
    }

    _rewardedAd!.fullScreenContentCallback =
        FullScreenContentCallback<RewardedAd>(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    _rewardedAd = null;
  }
}
