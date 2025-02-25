import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/services/admob_easy_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/utils/colors.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/widgets/ShimmerAd/ShimmerAd.dart';
import 'package:provider/provider.dart';

class ScreenFour extends StatefulWidget {
  const ScreenFour({super.key});

  @override
  State<ScreenFour> createState() => _ScreenFourState();
}

class _ScreenFourState extends State<ScreenFour> {
  bool isNativeAdLoaded = false;
  @override
  void initState() {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    super.initState();
    if (adConfig.nativeOnboarding4) {
      // _initializeNativeAd();
    }
    // _initializeNativeAd();
  }

  /// Initialize the AdMob Native Ad
  void _initializeNativeAd() async {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    AdmobEasy.instance.initialize(
      androidNativeAdID: adConfig.nativeOnboarding4Id, // Test Ad ID
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
              'icons/new/screen_four.webp',
              width: 300.w,
              height: 300.h,
            ),
            SizedBox(height: 100.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      localization.printLabels,
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
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      localization.printAnyLabelWithHigh,
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
                  // isNativeAdLoaded && adConfig.nativeOnboarding4
                  //     ? AdmobEasyNative.smallTemplate(
                  //         minWidth: 320,
                  //         minHeight: 50,
                  //         maxWidth: 400,
                  //         maxHeight: 85,
                  //         onAdClicked: (ad) => print("Ad Clicked"),
                  //         onAdImpression: (ad) => print("Ad Impression Logged"),
                  //         onAdClosed: (ad) => print("Ad Closed"),
                  //       )
                  //     : adConfig.nativeOnboarding4
                  //         ? ShimmerLoadingBanner(height: 85, width: 350.w)
                  //         : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
