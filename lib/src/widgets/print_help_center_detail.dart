import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpCenterDetail extends StatefulWidget {
  final String title;

  const HelpCenterDetail({super.key, required this.title});

  @override
  State<HelpCenterDetail> createState() => _HelpCenterDetailState();
}

class _HelpCenterDetailState extends State<HelpCenterDetail> {
  late List<String> items = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final localization = AppLocalizations.of(context)!;

    items = [
      localization.hp,
      localization.epson,
      localization.xerox,
      localization.canon,
      localization.toshiba,
      localization.ricoh,
      localization.brother,
      localization.dell,
      localization.kyocera,
    ];
  }

  final List<Color> textColors = [
    AppColor.blue,
    AppColor.red,
    AppColor.green,
    AppColor.orange,
    AppColor.purple,
    AppColor.teal,
    AppColor.indigo,
    AppColor.lime,
  ];

  @override
  Widget build(BuildContext context) {
    Widget buildPrinterOption(BuildContext context, String printerName) {
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: AppColor.menuColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrinterDetails(printerName: printerName),
              ),
            );
          },
          title: Text(
            printerName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.fontSize,
              color: AppColor.whiteColor,
            ),
          ),
          trailing: SvgPicture.asset(
            "icons/next_arrow_icon.svg",
            semanticsLabel: 'A red up arrow',
          ),
        ),
      );
    }

    Widget buildPrinterDefaults(BuildContext context, String text) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.fontSize,
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  // back button
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
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 17.fontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHelpContent(
                      context,
                      buildPrinterOption,
                      buildPrinterDefaults,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.8,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1.w,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              items[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColors[index % textColors.length],
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHelpContent(
    BuildContext context,
    Widget Function(BuildContext, String) buildPrinterOption,
    Widget Function(BuildContext, String) buildPrinterDefaults,
  ) {
    final localization = AppLocalizations.of(context)!;

    if (widget.title == localization.howCanIConnectWithMyPrinter) {
      return Column(
        children: [
          buildPrinterOption(context, localization.hpPrinters),
          buildPrinterOption(context, localization.brother),
          buildPrinterOption(context, localization.epson),
          buildPrinterOption(context, localization.canon),
          buildPrinterOption(context, localization.fujiXerox),
          buildPrinterOption(context, localization.lexmark),
        ],
      );
    } else if (widget.title == localization.reviewTheInstructionBefore) {
      return Column(
        children: [
          buildPrinterDefaults(context, localization.instruction1),
          buildPrinterDefaults(context, localization.instruction2),
          buildPrinterDefaults(context, localization.instruction3),
          buildPrinterDefaults(context, localization.instruction4),
          buildPrinterDefaults(context, localization.instruction5),
          buildPrinterDefaults(context, localization.instruction6),
          buildPrinterDefaults(context, localization.instruction7),
          _buildGridContent(context),
        ],
      );
    } else if (widget.title == localization.infoAboutMobilePrint) {
      return Column(
        children: [
          buildInfoAbout(context, 0, "", localization.infoMobilePrint,
              localization: localization),
          buildInfoAbout(context, 1, localization.simplePrinting,
              localization.simplePrintingDetail,
              localization: localization),
          buildInfoAbout(context, 2, localization.previewAndControl,
              localization.previewAndControlDetail,
              localization: localization),
          buildInfoAbout(context, 3, localization.getMoreGetSmart,
              localization.getMoreGetSmartDetail,
              localization: localization),
        ],
      );
    } else if (widget.title == localization.howToUseAppForPrinting) {
      return Column(
        children: [
          buildIconWithTitleAndDetails(
            context,
            "icons/open_the_app.svg",
            localization.openTheApp,
            localization.openTheAppDetail,
          ),
          buildIconWithTitleAndDetails(
            context,
            "icons/connecting_printer.svg",
            localization.connectingToPrinter,
            localization.connectingToPrinterDetail,
          ),
          buildIconWithTitleAndDetails(
            context,
            "icons/print_a_document.svg",
            localization.printADocument,
            localization.printADocumentDetail,
          ),
          buildIconWithTitleAndDetails(
            context,
            "icons/scan_a_document.svg",
            localization.scanADocument,
            localization.scanADocumentDetail,
          ),
          buildIconWithTitleAndDetails(
            context,
            "icons/print_photos.svg",
            localization.printPhotos,
            localization.printPhotosDetail,
          ),
        ],
      );
    } else if (widget.title == localization.help) {
      return Column(
        children: [Text(localization.openDefaultEmailApp)],
      );
    } else {
      return Center(child: Text(localization.noAdditionalDetails));
    }
  }

  // Widget _buildHelpContent(
  Widget buildIconWithTitleAndDetails(
      BuildContext context, String icon, String title, String details) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon on the left
              SvgPicture.asset(
                icon,
                width: 24.0,
                height: 24.0,
                // Uncomment to apply color filter to icon
                // colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                semanticsLabel: 'Icon for $title',
              ),
              SizedBox(width: 16.0), // Space between icon and title
              // Title next to the icon
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Space between title row and description
          // Details text below icon and title
          Text(
            details,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoAbout(
    BuildContext context,
    int index,
    String title,
    String description, {
    required AppLocalizations localization,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index == 0)
            Text(
              description,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.fontSize,
              ),
            )
          else ...[
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.fontSize,
              ),
            ),
          ],
          if (index == 3)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                localization.happyPrinting,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.fontSize,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

// Widget buildHowToUseAppForPrinting(
//     BuildContext context, int index, String title, String description) {
//   return Container(
//     alignment: Alignment.centerLeft,
//     padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (index == 0)
//           Text(
//             description,
//             style: TextStyle(
//               fontSize: 14.0,
//             ),
//           )
//         else ...[
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 14.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 4.0), // Spacing between title and description
//           Text(
//             description,
//             style: TextStyle(
//               fontSize: 14.0,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//         if (index == 3)
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: Text(
//               'Happy Printing',
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontStyle: FontStyle.italic,
//                 // color: Colors.blueAccent,
//               ),
//             ),
//           ),
//       ],
//     ),
//   );
// }
}

class PrinterDetails extends StatelessWidget {
  final String printerName;

  const PrinterDetails({super.key, required this.printerName});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return printerName == localization.hpPrinters ||
            printerName == localization.epson
        ? DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  printerName,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 21.fontSize,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48.0),
                  child: Theme(
                    data: ThemeData(
                      dividerColor: Colors.grey,
                    ),
                    child: TabBar(
                      labelColor: AppColor.menuColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColor.menuColor,
                      tabs: [
                        Tab(text: localization.touchScreenPrinters),
                        Tab(text: localization.buttonPrinters),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  _buildPrinterSteps(
                    context,
                    isTouchScreen: true,
                    localization: localization,
                  ),
                  _buildPrinterSteps(
                    context,
                    isTouchScreen: false,
                    localization: localization,
                  ),
                ],
              ),
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
                    decoration: BoxDecoration(
                      color: AppColor.menuColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Print button action here
                        openPlayStoreApp(
                          context,
                          localization: localization,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        child: Text(
                          localization.setUpPrintServices,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : printerName == localization.brother ||
                printerName == localization.canon ||
                printerName == localization.fujiXerox ||
                printerName == localization.lexmark
            ? Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: Text(
                    printerName,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 21.fontSize,
                    ),
                  ),
                ),
                body: _buildPrinterSteps(
                  context,
                  isTouchScreen: false,
                  localization: localization,
                ),
                bottomNavigationBar: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        color: AppColor.menuColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Print button action here
                          openPlayStoreApp(
                            context,
                            localization: localization,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          child: Text(
                            localization.setUpPrintServices,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.fontSize,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : throw Exception(
                "${localization.unknownPrinterName} $printerName");
  }

  void openPlayStoreApp(BuildContext context,
      {required AppLocalizations localization}) async {
    var whichApp;
    var appId = "com.hp.android.printservice";
    if (printerName == localization.hpPrinters) {
      appId = Platform.isAndroid
          ? 'com.hp.android.printservice'
          : 'YOUR_IOS_APP_ID';
      whichApp = "";
    } else if (printerName == localization.epson) {
      appId = Platform.isAndroid ? 'epson.print' : 'YOUR_IOS_APP_ID';
      whichApp = "";
    } else if (printerName == localization.brother) {
      appId = Platform.isAndroid
          ? 'com.brother.mfc.mobileconnect'
          : 'YOUR_IOS_APP_ID';
      whichApp = "";
    } else if (printerName == localization.canon) {
      appId = Platform.isAndroid
          ? 'jp.co.canon.bsd.ad.pixmaprint'
          : 'YOUR_IOS_APP_ID';
      whichApp = "";
    } else if (printerName == localization.fujiXerox) {
      appId = Platform.isAndroid ? 'com.xerox.printservice' : 'YOUR_IOS_APP_ID';
      whichApp = "";
    } else if (printerName == localization.lexmark) {
      appId = Platform.isAndroid
          ? 'com.lexmark.mobile.lxkprint'
          : 'YOUR_IOS_APP_ID';
      whichApp = "";
    }

    // switch (printerName) {
    //   case localization.hpPrinters:
    //     appId = Platform.isAndroid
    //         ? 'com.hp.android.printservice'
    //         : 'YOUR_IOS_APP_ID';
    //     whichApp = "";
    //     break;
    //   case "Epson":
    //     appId = Platform.isAndroid ? 'epson.print' : 'YOUR_IOS_APP_ID';
    //     whichApp = "";
    //     break;
    //   case "Brother":
    //     appId = Platform.isAndroid
    //         ? 'com.brother.mfc.mobileconnect'
    //         : 'YOUR_IOS_APP_ID';
    //     whichApp = "";
    //     break;
    //   case "Canon":
    //     appId = Platform.isAndroid
    //         ? 'jp.co.canon.bsd.ad.pixmaprint'
    //         : 'YOUR_IOS_APP_ID';
    //     whichApp = "";
    //     break;
    //   case "Fuji Xerox":
    //     appId =
    //         Platform.isAndroid ? 'com.xerox.printservice' : 'YOUR_IOS_APP_ID';
    //     whichApp = "";
    //     break;
    //   case "Lexmark":
    //     appId = Platform.isAndroid
    //         ? 'com.lexmark.mobile.lxkprint'
    //         : 'YOUR_IOS_APP_ID';
    //     whichApp = "";
    //     break;
    // }
    // open the play store app
    whichApp = 'whatsapp://send?phone=255634523';
    if (Platform.isAndroid || Platform.isIOS) {
      final url = Uri.parse(
        Platform.isAndroid
            // ? "market://details?id=$appId"
            ? "https://play.google.com/store/apps/details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Widget _buildPrinterSteps(
    BuildContext context, {
    required bool isTouchScreen,
    required AppLocalizations localization,
  }) {
    List<Map<String, String>> steps = [];

    if (printerName == localization.hpPrinters) {
      if (isTouchScreen) {
        steps = [
          {
            "title": localization.stepOne,
            "description": localization.placePrinterNearWifiRouter
          },
          {
            "title": localization.stepTwo,
            "description":
                localization.makeSurePaperIsLoadedInMainTrayAndTurnOnPrinter
          },
          {
            "title": localization.stepThree,
            "description": localization.touchTheWifiIconToDisplayTheWifiStatus
          },
          {
            "title": localization.stepFour,
            "description":
                localization.installTheHpSmartAppFromThePlayStoreAndFollow
          },
          {
            "title": localization.stepFive,
            "description":
                localization.goToYourWifiSettingsOnThisMobileDeviceAndSelectHp
          },
          {
            "title": localization.stepSix,
            "description":
                localization.reopenTheHpSmartAppToCheckThePrinterStatus
          },
          {
            "title": localization.stepSeven,
            "description":
                localization.enterTheWifiNetworkPasswordToConnectItCanTakeUpTo
          },
          {
            "title": localization.stepEight,
            "description":
                localization.ifTheBlueLightOnYourPrinterIsBlinkingYourPrinter
          },
          {
            "title": localization.stepNine,
            "description": localization.tapTheButtonBelowToInstallThePrinter
          },
        ];
      } else {
        steps = [
          {
            "title": localization.stepOne,
            "description": localization.placePrinterNearWifiRouter
          },
          {
            "title": localization.stepTwo,
            "description":
                localization.makeSurePaperIsLoadedInMainTrayAndTurnOnPrinter
          },
          {
            "title": localization.stepThree,
            "description": localization.pressAndHoldTheWirelessButtonForAtLeast5
          },
          {
            "title": localization.stepFour,
            "description":
                localization.makeSurePaperIsLoadedInMainTrayAndTurnOnPrinter
          },
          {
            "title": localization.stepFive,
            "description":
                localization.goToYourWifiSettingsOnThisMobileDeviceAndSelectHp
          },
          {
            "title": localization.stepSix,
            "description":
                localization.reopenTheHpSmartAppToCheckThePrinterStatus
          },
          {
            "title": localization.stepSeven,
            "description":
                localization.enterTheWifiNetworkPasswordToConnectItCanTakeUpTo
          },
          {
            "title": localization.stepEight,
            "description":
                localization.ifTheBlueLightOnYourPrinterIsBlinkingYourPrinter
          },
          {
            "title": localization.stepNine,
            "description": localization.tapTheButtonBelowToInstallThePrinter
          },
        ];
      }
    } else if (printerName == 'Brother' ||
        printerName == 'Canon' ||
        printerName == 'Fuji Xerox' ||
        printerName == 'Lexmark') {
      steps = [
        {
          "title": localization.stepOne,
          "description": localization.placeThePrinterNearTheWifiRouterTurn
        },
        {
          "title": localization.stepTwo,
          "description":
              localization.onYourPrinterGoToSettingsNetworkSettingsWiFi
        },
        {
          "title": localization.stepThree,
          "description":
              localization.followTheInstructionsOnThePrintersScreenAndSetup
        },
        {
          "title": localization.stepFour,
          "description": localization.followTheSetupGuideInTheUserManual
        },
        {
          "title": localization.stepFive,
          "description": localization.selectTheSsidShownOnThePrintersScreen
        },
        {
          "title": localization.stepSix,
          "description": localization.waitUntilTheProcessEndsTapTheButtonBelow
        },
      ];
    } else if (printerName == 'Epson') {
      if (isTouchScreen) {
        steps = [
          {
            "title": localization.stepOne,
            "description": localization.placeThePrinterNearTheWifiRouterTurn
          },
          {
            "title": localization.stepTwo,
            "description":
                localization.onYourPrinterGoToSettingsNetworkSettingsWiFi
          },
          {
            "title": localization.stepThree,
            "description":
                localization.followTheInstructionsOnThePrintersScreenAndSetup
          },
          {
            "title": localization.stepFour,
            "description": localization.onYourPhoneOpenTheWifiSettingsFromThe
          },
          {
            "title": localization.stepFive,
            "description": localization.selectTheSsidShownOnThePrintersScreen
          },
        ];
      } else {
        steps = [
          {
            "title": localization.stepOne,
            "description": localization.placeThePrinterNearTheWifiRouterTurn
          },
          {
            "title": localization.stepTwo,
            "description":
                localization.makeSurePaperIsLoadedInMainTrayAndTurnOnPrinter
          },
          {
            "title": localization.stepThree,
            "description":
                localization.pressTheWiFiButtonAndTheNetworkStatusButton
          },
          {
            "title": localization.stepFour,
            "description": localization.loadPaper
          },
          {
            "title": localization.stepFive,
            "description":
                localization.holdDownTheNetworkStatusButtonOnThePrinters
          },
          {
            "title": localization.stepSix,
            "description":
                localization.checkTheSsidAndPasswordPrintedOnTheNetwork
          },
          {
            "title": localization.stepSeven,
            "description":
                localization.enterTheWifiNetworkPasswordToConnectItCan
          },
          {
            "title": localization.stepEight,
            "description": localization.waitUntilTheProcessEndsTapTheButtonBelow
          },
        ];
      }
    } else {
      throw Exception("${localization.unknownPrinterName} $printerName");
    }

    return ListView.builder(
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        return ListTile(
          title: Text(
            step["title"]!,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 16.fontSize,
            ),
          ),
          subtitle: Text(
            step["description"]!,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 13.fontSize,
            ),
          ),
        );
      },
    );
  }
}
