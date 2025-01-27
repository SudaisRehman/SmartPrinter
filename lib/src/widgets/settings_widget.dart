import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:printer_app/src/providers/nav_bar_provider.dart';
import 'package:printer_app/src/screens/report_issue_screen.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/widgets/subscription_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/how_to_connect_screen.dart';
import '../screens/languages_screen.dart';
import '../screens/print_brands_screen.dart';
import '../utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late List<String> helpItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final localization = AppLocalizations.of(context)!;

    helpItems = [
      localization.printerCompatibleList,
      localization.changeLanguage,
      localization.manageSubscription,
      localization.howToConnect,
      localization.general,
      localization.reportAnIssue,
      localization.proSupport,
      localization.sendLove,
      localization.termsOfUse,
      localization.privacyPolicy,
      localization.shareApp,
      localization.moreApps,
    ];
  }

  // Helper function to get the icon based on the item text
  String getIconForItem(String item) {
    final localization = AppLocalizations.of(context)!;

    if (item == localization.printerCompatibleList) {
      return "icons/settings_printer.svg";
    } else if (item == localization.changeLanguage) {
      return "icons/settings_language.svg";
    } else if (item == localization.manageSubscription) {
      return "icons/settings_subscription.svg";
    } else if (item == localization.howToConnect) {
      return "icons/settings_how_to.svg";
    } else if (item == localization.reportAnIssue) {
      return "icons/settings_report.svg";
    } else if (item == localization.proSupport) {
      return "icons/settings_pro_support.svg";
    } else if (item == localization.sendLove) {
      return "icons/settings_send_a_love.svg";
    } else if (item == localization.termsOfUse) {
      return "icons/settings_terms_of.svg";
    } else if (item == localization.privacyPolicy) {
      return "icons/settings_privacy_policy.svg";
    } else if (item == localization.shareApp) {
      return "icons/settings_share.svg";
    } else if (item == localization.moreApps) {
      return "icons/settings_more_apps.svg";
    } else {
      return "icons/question_mark_icon.svg"; // Fallback for unknown items
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final navBarProvider = Provider.of<NavBarProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        navBarProvider.setNavBarIndex(0);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 15.w,
                  bottom: 10.h,
                  top: 10.h,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 40.w),
                        child: Text(
                          localization.setting,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.fontSize,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubscriptionPage(),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          width: 30.w,
                          height: 30.h,
                          "icons/diamond_icon.svg",
                          semanticsLabel: 'A red up arrow',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // content view

              Expanded(
                child: ListView.builder(
                  itemCount: helpItems.length,
                  itemBuilder: (context, index) {
                    if (index == 4) {
                      return Text(
                        helpItems[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16.fontSize,
                        ),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.menuColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          switch (index) {
                            case 0: // Print Brands Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrintBrandsScreen(),
                                ),
                              );
                            case 1: // Languages Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LanguagesScreen(isFirstTime: false),
                                ),
                              );
                            case 2: // Open Subs in Play Store
                              manageSubsOnTap(context, localization);
                            case 3: // How To Connect Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HowToConnectScreen(),
                                ),
                              );
                            // At index 4 there is a Text
                            case 5: // Report Issue Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportIssueScreen(),
                                ),
                              );
                            // Show Love Bottom Sheet
                            case 7:
                              showModalBottomSheet(
                                barrierColor:
                                    AppColor.blackColor.withOpacity(.8),
                                context: context,
                                backgroundColor: AppColor.transparentColor,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return showLoveContainer(
                                    context: context,
                                    localization: localization,
                                  );
                                },
                              );

                            // Show Share Bottom Sheet
                            case 10:
                              showModalBottomSheet(
                                barrierColor:
                                    AppColor.blackColor.withOpacity(.8),
                                context: context,
                                backgroundColor: AppColor.transparentColor,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return shareAppContainer(
                                    context: context,
                                    localization: localization,
                                  );
                                },
                              );
                          }
                          /*
                          var pageToOpen = helpItems[index] == "Pro Support"
                              ? MaterialPageRoute(
                                  builder: (context) => SubscriptionPage(),
                                )
                              : MaterialPageRoute(
                                  builder: (context) =>
                                      HelpCenterDetail(title: helpItems[index]),
                                );

                          Navigator.push(
                              context,
                              // if 'Help' please open email app
                              // if 'Pro Support' open full screen dialog
                              pageToOpen);
                          */
                        },
                        leading: SvgPicture.asset(
                          width: 30.w,
                          height: 30.h,
                          getIconForItem(helpItems[index]),
                          semanticsLabel: helpItems[index],
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        title: Text(
                          helpItems[index],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12.fontSize,
                            color: Colors.white,
                          ),
                        ),
                        trailing: SvgPicture.asset(
                          "icons/next_arrow_icon.svg",
                          semanticsLabel: 'A red up arrow',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget shareAppContainer({
    required BuildContext context,
    required AppLocalizations localization,
  }) {
    return Container(
      width: double.infinity,
      height: 220.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(bottom: 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'icons/new/share_icon.webp',
            width: 50.w,
            height: 50.h,
          ),
          SizedBox(height: 15.h),
          Text(
            localization.printSmartlyTogether,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 15.fontSize,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            localization.shareItWithYour,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 13.fontSize,
            ),
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: () {},
            child: Container(
              width: 150.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: AppColor.mainThemeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  localization.shareApp,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16.fontSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showLoveContainer({
    required BuildContext context,
    required AppLocalizations localization,
  }) {
    return Container(
      width: double.infinity,
      height: 220.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(bottom: 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(height: 5.h),
          Image.asset(
            'icons/new/big_star.webp',
            width: 50.w,
            height: 50.h,
          ),
          SizedBox(height: 15.h),
          Text(
            localization.lovedOutSmartPrinter,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 15.fontSize,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            localization.showYourSupportByRating,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 13.fontSize,
            ),
          ),
          SizedBox(height: 12.h),
          Image.asset(
            'icons/new/group_stars.webp',
            width: 230.w,
          ),
          SizedBox(height: 13.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 100.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: AppColor.mainThemeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      localization.cancel,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16.fontSize,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 100.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.mainThemeColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      localization.rateUs,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: AppColor.mainThemeColor,
                        fontSize: 16.fontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void manageSubsOnTap(
      BuildContext context, AppLocalizations localization) async {
    const String playStoreSubscriptionUrl =
        'https://play.google.com/store/account/subscriptions';
    final Uri uri = Uri.parse(playStoreSubscriptionUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localization.couldNotOpenThePlayStore),
        ),
      );
    }
  }
}
