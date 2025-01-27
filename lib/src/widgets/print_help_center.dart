// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import '../utils/colors.dart';
import 'print_help_center_detail.dart';
import 'subscription_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintHelpCenter extends StatefulWidget {
  const PrintHelpCenter({super.key});

  @override
  State<PrintHelpCenter> createState() => _PrintHelpCenterState();
}

class _PrintHelpCenterState extends State<PrintHelpCenter> {
  late List<String> helpItems = [];

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    final localization = AppLocalizations.of(context)!;

    helpItems = [
      localization.reviewTheInstructionBefore,
      localization.infoAboutMobilePrint,
      localization.howToUseAppForPrinting,
      localization.howCanIConnectWithMyPrinter,
      localization.help,
      localization.proSupport,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Column(
          children: [
            // appbar
            Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 15.w,
                bottom: 10.h,
                top: 10.h,
              ),
              child: Row(
                children: [
                  // back button
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child:  Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20.iconSize,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 40.w),
                      child: Text(
                        localization.helpCenter,
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
                        "icons/diamond_icon.svg",
                        semanticsLabel: 'A red up arrow',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: helpItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.menuColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: SvgPicture.asset(
                        helpItems[index] == localization.proSupport
                            ? "icons/diamond_icon.svg"
                            : "icons/question_mark_icon.svg",
                        semanticsLabel: 'A red up arrow',
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ), // Left icon
                      title: Text(
                        helpItems[index],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 13.fontSize,
                        ),
                      ),
                      trailing: SvgPicture.asset(
                        "icons/next_arrow_icon.svg",
                        semanticsLabel: 'A red up arrow',
                      ),
                      onTap: () {
                        var pageToOpen =
                            helpItems[index] == localization.proSupport
                                ? MaterialPageRoute(
                                    builder: (context) => SubscriptionPage(),
                                  )
                                : MaterialPageRoute(
                                    builder: (context) => HelpCenterDetail(
                                      title: helpItems[index],
                                    ),
                                  );

                        Navigator.push(
                          context,
                          // if 'Help' please open email app
                          // if 'Pro Support' open full screen dialog
                          pageToOpen,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
