// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:printer_app/Constants/Constant.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/screens/home_widget.dart';
import 'package:printer_app/src/screens/languages_screen.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';

import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  InterstitialAd? interstitialAd;

  SplashScreen({Key? key, required this.interstitialAd}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // InterstitialAd? widget.interstitialAd;

  @override
  void initState() {
    super.initState();
    print('Splash Screen');
    // _loadInterstitialAd();
    // Future.delayed(Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
      // await adConfig
      //     .initializeRemoteConfig(); // Wait here to load remote config
      print('Splash Interstitial: ${adConfig.splashInterstitial}');
      // if (adConfig.splashInterstitial) {
      // _loadInterstitialAd();
      print('Interstitial Ad Loaded');
      // }
    });
    Future.delayed(Duration(seconds: 3));
    // loadInterstitialAd();
  }

  void _showInterstitialAd() {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    if (widget.interstitialAd != null && adConfig.splashInterstitial) {
      // Ensure the ad is not null
      widget.interstitialAd!.show();
      setState(() {
        widget.interstitialAd = null; // Dispose of the ad after showing
        var isInterstitialAdLoaded = false;
      });
      // _loadInterstitialAd(); // Load a new interstitial ad
    } else {
      print('Tapp Interstitial ad not loaded yet.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('icons/new/background.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/Smart printer.json',
                width: 250.w,
                height: 250.h,
              ),
              SizedBox(height: 50.h),
              Text(
                localization.smartPrinter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30.fontSize,
                ),
              ),
              Text(
                localization.scanAndPrintYourDocuments,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14.fontSize,
                ),
              ),
              SizedBox(height: 35.h),
              InkWell(
                onTap: () {
                  navigateBasedOnPreference(context);
                },
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff17BDD3),
                  ),
                  child: Center(
                    child: Text(
                      localization.start,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 17.fontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateBasedOnPreference(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTrue = prefs.getBool('isTrue') ?? false;
    print('isTrue: $isTrue');
    // if () {
    _showInterstitialAd();
    // await Future.delayed(Duration(seconds: 2)); // Wait for the ad to be shown
    // }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isTrue ? HomeWidget() : LanguagesScreen(isFirstTime: true),
      ),
    );
  }
}
