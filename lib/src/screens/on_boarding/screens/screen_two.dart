import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/services/admob_easy_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/utils/colors.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/widgets/ShimmerAd/ShimmerAd.dart';
import 'package:provider/provider.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  bool isNativeAdLoaded = false;
  @override
  @override
  void initState() {
    super.initState();
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    if (adConfig.nativeOnboarding1_2) {
      // _initializeNativeAd();
    }
    // _initializeNativeAd();
  }

  /// Initialize the AdMob Native Ad
  void _initializeNativeAd() async {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    AdmobEasy.instance.initialize(
      androidNativeAdID: adConfig.nativeOnboarding1_2Id, // Test Ad ID
    );

    // Simulating ad load delay (Ad loading happens asynchronously)
    await Future.delayed(const Duration(seconds: 2));

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
              'icons/new/screen_two.webp',
              width: 300.w,
              height: 300.h,
            ),
            SizedBox(height: 100.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Text(
                localization.importFilesFromAnyWhere,
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
                localization.easilyScanAndPrintYourImportant,
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
          ],
        ),
      ),
    );
  }
}
