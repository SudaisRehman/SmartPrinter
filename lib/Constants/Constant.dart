class AdIds {
  // Set this to true when you want to use real ads, false for test ads
  static bool isReal = false;

  // App Open Ad ID
  static String get appOpenAdId {
    return isReal
        ? 'ca-app-pub-9498660037072845/8424953411'
        : 'ca-app-pub-3940256099942544/9257395921';
  }

  // Banner Ads IDs
  static String get bannerSideBarId {
    return isReal
        ? 'ca-app-pub-9498660037072845/6100342286'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerGalleryScreenId {
    return isReal
        ? 'ca-app-pub-9498660037072845/1616401866'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerGotoGalleryScreenId {
    return isReal
        ? ' ca-app-pub-9498660037072845/2737911841'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerPhotoVideoId {
    return isReal
        ? 'ca-app-pub-9498660037072845/1636183780'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerWelcomeScreenId {
    return isReal
        ? 'ca-app-pub-9498660037072845/1003265566'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerMapScreenId {
    return isReal
        ? 'ca-app-pub-9498660037072845/2507918921'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerLogoScreenId {
    return isReal
        ? 'ca-app-pub-9498660037072845/5172503496'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerOnboarding1Id {
    return isReal
        ? 'ca-app-pub-9498660037072845/3887341985'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerOnboarding2Id {
    return isReal
        ? 'ca-app-pub-9498660037072845/7343371267'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerOnboarding3Id {
    return isReal
        ? 'ca-app-pub-9498660037072845/4717207929'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerTemplateScreenId {
    return isReal
        ? 'ca-app-pub-9498660037072845/1051195588'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get bannerHomeScreenId {
    return isReal
        ? 'ca-app-pub-9498660037072845/7534942954'
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  // Interstitial Ads IDs
  static String get interPhotoVideoBackId {
    return isReal
        ? 'ca-app-pub-9498660037072845/1249170971'
        : 'ca-app-pub-3940256099942544/1033173712';
  }

  static String get interstitialHomeScreenId {
    return isReal
        ? 'ca-app-pub-9498660037072845/1249170971'
        : 'ca-app-pub-3940256099942544/1033173712';
  }

  // static String get interstitialAdsPermissionId {
  //   return isReal
  //       ? 'ca-app-pub-4583708687352330/5357312698'
  //       : 'ca-app-pub-3940256099942544/1033173712';
  // }

  static String get splashInterstitialId {
    return isReal
        ? ' ca-app-pub-9498660037072845/5798790073'
        : 'ca-app-pub-3940256099942544/1033173712';
  }

  static String get bannerLanguageScreenId {
    return isReal
        ? 'ca-app-pub-9498660037072845/1636183780'
        : 'ca-app-pub-3940256099942544/6300978111';
  }
}
