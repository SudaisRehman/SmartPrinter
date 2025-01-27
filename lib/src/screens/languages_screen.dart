import 'dart:async';
import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/services/admob_easy_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/widgets/ShimmerAd/ShimmerAd.dart';
import 'package:provider/provider.dart';
import '../providers/languages_provider.dart';
import '../utils/colors.dart';
import '../utils/my_radio_button.dart';
import 'on_boarding/on_boarding_screen.dart';

class LanguagesScreen extends StatefulWidget {
  final bool isFirstTime;

  const LanguagesScreen({super.key, required this.isFirstTime});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int _selectedIndex = 0;
  String? _selectedLanguageCode;
  bool isNativeAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInitialLanguage();
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    // if (adConfig.nativeLanguage) {
    _initializeNativeAd();
    // }
    // _initializeNativeAd();
  }

  void _initializeNativeAd() async {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    AdmobEasy.instance.initialize(
      androidNativeAdID: adConfig.nativeLanguageId, // Test Ad ID
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

  Future<void> _loadInitialLanguage() async {
    final languagesProvider =
        Provider.of<LanguagesProvider>(context, listen: false);
    await languagesProvider.loadStoredLanguage();

    setState(() {
      _selectedLanguageCode = languagesProvider.appLocale.languageCode;
      _selectedIndex = languagesProvider.languagesMap.keys
          .toList()
          .indexOf(_selectedLanguageCode!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = Provider.of<AdConfigProvider>(context);
    final localization = AppLocalizations.of(context)!;
    final languagesProvider = Provider.of<LanguagesProvider>(context);
    final allLanguages = languagesProvider.languagesMap.entries.toList();

    bool isFirstTime = widget.isFirstTime;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: appBar(
        context: context,
        onTap: () {
          if (_selectedLanguageCode != null) {
            languagesProvider.changeLanguage(Locale(_selectedLanguageCode!));
            if (isFirstTime) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OnBoardingScreen(),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          }
        },
        localization: localization,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 30.h),
                itemCount: allLanguages.length,
                itemBuilder: (context, index) {
                  final code = allLanguages[index].key;
                  final languageName =
                      _getLocalizedLanguageName(localization, code);
                  final language = allLanguages[index].value;
                  final isSelected = _selectedIndex == index;

                  return MyRadioButton(
                    imagePath: language['flag']!,
                    text: languageName,
                    isFilled: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        _selectedLanguageCode = code;
                      });
                    },
                  );
                },
              ),
            ),
            if (adConfig.nativeLanguage)
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

  PreferredSizeWidget? appBar({
    required BuildContext context,
    required void Function()? onTap,
    required AppLocalizations localization,
  }) {
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 24.iconSize,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(width: 5.w),
          Text(
            localization.languages,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20.fontSize,
              color: AppColor.blackColor,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Image.asset(
                'icons/new/tick_icon.webp',
                width: 20.w,
                height: 20.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedLanguageName(AppLocalizations localization, String code) {
    switch (code) {
      case 'en':
        return localization.english;
      case 'ja':
        return localization.japanese;
      case 'hi':
        return localization.hindi;
      case 'es':
        return localization.spanish;
      case 'fr':
        return localization.french;
      case 'ar':
        return localization.arabic;
      case 'bn':
        return localization.bengali;
      case 'ru':
        return localization.russian;
      case 'it':
        return localization.italian;
      default:
        return localization.english;
    }
  }
}
