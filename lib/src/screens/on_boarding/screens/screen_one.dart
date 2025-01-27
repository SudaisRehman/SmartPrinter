import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/services/admob_easy_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/utils/colors.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/widgets/ShimmerAd/ShimmerAd.dart';
import 'package:provider/provider.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  bool isNativeAdLoaded = false; // Tracks ad loading state

  @override
  void initState() {
    super.initState();
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    if (adConfig.nativeOnboarding1_2) {
      _initializeNativeAd();
    }
  }

  // / Initialize the AdMob Native Ad
  void _initializeNativeAd() async {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    AdmobEasy.instance.initialize(
      androidNativeAdID: adConfig.nativeOnboarding1_2Id, // Test Ad ID
    );

    // Simulating ad load delay (Ad loading happens asynchronously)
    await Future.delayed(const Duration(seconds: 1));

    // Update the state to simulate the ad being loaded
    if (mounted) {
      setState(() {
        isNativeAdLoaded = true; // Simulating successful ad load
      });
    }
    print('Native Ad loaded');
  }

  // void _initializeNativeAd() async {
  //   final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
  //   if (!adConfig.nativeOnboarding1_2) return;

  //   AdmobEasy.instance.initialize(
  //     androidNativeAdID: adConfig.nativeOnboarding1_2Id,
  //   );

  //   AdmobEasy.instance.nativeAdID = adConfig.nativeOnboarding1_2Id;

  //   // Start listening for ad events
  //   AdmobEasy.instance.nativeAdListener = NativeAdListener(
  //     onAdLoaded: (ad) {
  //       if (mounted) {
  //         setState(() {
  //           isNativeAdLoaded = true; // Native ad is ready
  //         });
  //       }
  //     },
  //     onAdFailedToLoad: (ad, error) {
  //       print('NativeAd failed to load: $error');
  //       ad.dispose();
  //     },
  //   );

  //   // Load the native ad
  //   AdmobEasy.instance.loadNativeAd();
  // }
  @override
  Widget build(BuildContext context) {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    final localization = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 25.h),
            Image.asset(
              'icons/new/screen_one.webp',
              width: 300.w,
              height: 300.h,
            ),
            SizedBox(height: 100.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Text(
                localization.smartPrinter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 22.fontSize,
                  color: AppColor.blackColor,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.w),
              child: Text(
                localization.connectWithWifiAndPrint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 15.fontSize,
                  color: AppColor.blackColor,
                ),
              ),
            ),
            SizedBox(height: 180.h),

            /// Display shimmer or native ad dynamically
            if (adConfig.nativeOnboarding1_2)
              isNativeAdLoaded
                  ? AdmobEasyNative.smallTemplate(
                      minWidth: 320,
                      minHeight: 50,
                      maxWidth: 400,
                      maxHeight: 85,
                      onAdClicked: (ad) => print("Ad Clicked"),
                      onAdImpression: (ad) => print("Ad Impression Logged"),
                      onAdClosed: (ad) => print("Ad Closed"),
                    )
                  : ShimmerLoadingBanner(height: 100, width: double.infinity)
            else
              Container(),
          ],
        ),
      ),
    );
  }
}
