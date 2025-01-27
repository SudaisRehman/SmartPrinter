import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/services/admob_easy_native.dart';
import 'package:flutter/material.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/screens/home_widget.dart';
import 'package:printer_app/src/screens/on_boarding/screens/screen_five.dart';
import 'package:printer_app/src/screens/on_boarding/screens/screen_four.dart';
import 'package:printer_app/src/screens/on_boarding/screens/screen_one.dart';
import 'package:printer_app/src/screens/on_boarding/screens/screen_three.dart';
import 'package:printer_app/src/screens/on_boarding/screens/screen_two.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/widgets/subscription_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../providers/on_boarding_provider.dart';
import '../../utils/colors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isNativeAdLoaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _loadNativeAd();
  }

  @override
  Widget build(BuildContext context) {
    final onBoardingProvider = Provider.of<OnBoardingProvider>(context);
    final adConfigProvider =
        Provider.of<AdConfigProvider>(context, listen: false);
    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('icons/new/background.webp'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 20.h),
                child: InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isTrue', true);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeWidget(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      localization.skip,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14.fontSize,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: PageView(
                  controller: onBoardingProvider.pageController,
                  children: [
                    const ScreenOne(),
                    const ScreenTwo(),
                    const ScreenThree(),
                    const ScreenFour(),
                    const ScreenFive(),
                  ],
                  onPageChanged: (index) {
                    onBoardingProvider.setPageIndex(index);
                  },
                ),
              ),
              Positioned(
                bottom: 120.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SmoothPageIndicator(
                        controller: onBoardingProvider.pageController,
                        count: 5,
                        effect: ScaleEffect(
                          dotWidth: 7.w,
                          dotHeight: 7.h,
                          dotColor: const Color(0xffA1A1A1),
                          activeDotColor: AppColor.bluish,
                        ),
                      ),
                      SizedBox(width: 220.w),
                      // Spacer(),
                      GestureDetector(
                        onTap: onBoardingProvider.onLastPage
                            ? () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('isTrue', true);
                                if (!adConfigProvider.isSubscribed) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubscriptionPage(),
                                    ),
                                  );
                                } else {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('isTrue', true);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeWidget(),
                                    ),
                                  );
                                }
                              }
                            : () {
                                onBoardingProvider.pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              },
                        child: Image.asset(
                          'icons/new/arrow_forward.webp',
                          width: 40.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // Container(
              //   height: 80.h,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     border: Border.all(color: AppColor.bluish),
              //   ),
              //   child: Center(
              //     child: Text('Ad Here'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
