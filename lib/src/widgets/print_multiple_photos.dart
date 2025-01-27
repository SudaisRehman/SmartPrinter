// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/screens/print_web_page_screen.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:provider/provider.dart';
import '../database/app_database.dart';
import '../models/multi_print_menu.dart';
import '../utils/colors.dart';
import 'print_multiple_photos_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintMultiplePhotosWidget extends StatefulWidget {
  // whats the usage of 'final' before data_type
  final String buttonText;

  const PrintMultiplePhotosWidget.withMultiplePhotos({
    super.key,
    required this.buttonText,
  });

  @override
  State<PrintMultiplePhotosWidget> createState() => _PrintPhotoWidgetState();
}

class _PrintPhotoWidgetState extends State<PrintMultiplePhotosWidget>
    with SingleTickerProviderStateMixin {
  //
  bool isPrinterConnected = false;
  AppDatabase noteDatabase = AppDatabase.instance;
  late List<MultiPrintItem> multiPrintList = [];

  //
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdCollapsed = false;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    checkPrinterInDB();
    // Initialize the animation controller
    if (adConfig.bannerCollapsible) {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      );

      _heightAnimation = Tween<double>(begin: 255, end: 0.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      // Load the Banner Ad
      _bannerAd = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: adConfig.bannerCollapsibleId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            print("Banner Ad failed to load: $error");
            ad.dispose();
          },
        ),
        request: AdRequest(),
      )..load();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAdVisibility() {
    if (_isAdCollapsed) {
      _animationController.reverse(); // Expand
    } else {
      _animationController.forward(); // Collapse
    }
    setState(() {
      _isAdCollapsed = !_isAdCollapsed;
    });
  }

  void checkPrinterInDB() {
    noteDatabase.readAll().then((printerList) {
      setState(() {
        // _printListDataBase = printerList;
        print("printerList : ${printerList.length}");
        if (printerList.isEmpty) {
          isPrinterConnected = false;
        } else {
          isPrinterConnected = true;
        }
      });
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   //
  //   checkPrinterInDB();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localization = AppLocalizations.of(context)!;
    multiPrintList = [
      MultiPrintItem(
        isSelected: true,
        title: localization.twoPerSheet,
        heightWidth: localization.hundredByOneFifty,
        frame: localization.twoSquare,
        iconName: "icons/print_photo.png",
      ),
      MultiPrintItem(
        isSelected: false,
        title: localization.fourPerSheet,
        heightWidth: localization.oneFiftyByFifty,
        frame: localization.fourCube,
        iconName: "icons/print_photo.png",
      ),
      MultiPrintItem(
        isSelected: false,
        title: localization.threePerSheet,
        heightWidth: localization.hundredByThirty,
        frame: localization.threeSquare,
        iconName: "icons/print_photo.png",
      ),
      MultiPrintItem(
        isSelected: false,
        title: localization.fourPerSheet,
        heightWidth: localization.fiftyByFifty,
        frame: localization.fourCircle,
        iconName: "icons/print_photo.png",
      ),
      MultiPrintItem(
        isSelected: false,
        title: localization.sixPerSheet,
        heightWidth: localization.fiftyByThirty,
        frame: localization.sixSquare,
        iconName: "icons/print_photo.png",
      ),
      MultiPrintItem(
        isSelected: false,
        title: localization.eightPerSheet,
        heightWidth: localization.fiftyByThirty,
        frame: localization.eightSquare,
        iconName: "icons/print_photo.png",
      ),
    ];
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage,
      {required AppLocalizations localization}) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(localization.capturedWidgetScreenshot),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    final localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.lightBlueBg,
        body: Padding(
          padding: const EdgeInsets.only(),
          child: Column(
            children: [
              Padding(
                // appbar
                padding: EdgeInsets.only(
                  left: 10.0.w,
                  right: 15.0.w,
                  bottom: 10.0.h,
                  top: 10.0.h,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 40.w),
                        child: Text(
                          localization.selectLayout,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.fontSize,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // app content
              // grids
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: (1 / 1.2),
                          // childAspectRatio: (itemWidth / itemHeight),
                        ),
                        itemCount: multiPrintList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => {
                              for (var i = 0; i < multiPrintList.length; i++)
                                {multiPrintList[i].isSelected = false},
                              setState(() {
                                multiPrintList[index].isSelected = true;
                              }),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MultiplePhotosDetailWidget
                                            .withMultiplePhotos(
                                          multiPrintItem: multiPrintList[index],
                                        )
                                    /**/
                                    // DynamicGridWidget(),
                                    // ConvertToPdfPage(),
                                    /**/
                                    //     ImageSplitter(
                                    //   rows: 3,
                                    //   columns: 3,
                                    //   imageUrl:
                                    //       "https://cdn.pixabay.com/photo/2024/05/27/12/27/gargoyle-8791108_1280.jpg",
                                    // ),
                                    // ),
                                    /**/
                                    // DynamicGridWidget()),
                                    ),
                              )
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                                bottom: 5.h,
                              ),
                              padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                              // width: 150,
                              // height: 300,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: multiPrintList[index].isSelected
                                      ? AppColor.skyBlue
                                      : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Colors.white,
                              ),
                              child: Container(
                                margin:
                                    EdgeInsets.only(left: 10.w, right: 10.w),
                                // color: Colors.blue,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // logic for grids
                                    if (multiPrintList[index].frame ==
                                        localization.twoSquare)
                                      twoSquares(index)
                                    else if (multiPrintList[index].frame ==
                                        localization.fourCube)
                                      fourSquares(index)
                                    else if (multiPrintList[index].frame ==
                                        localization.threeSquare)
                                      threeSquares(index)
                                    else if (multiPrintList[index].frame ==
                                        localization.fourCircle)
                                      fourCircles(index)
                                    else if (multiPrintList[index].frame ==
                                        localization.sixSquare)
                                      sixSquares(index)
                                    else if (multiPrintList[index].frame ==
                                        localization.eightSquare)
                                      eightSquares(index)
                                    else
                                      Spacer(),
                                    /////
                                    /* title and scale */
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Column(
                                        children: [
                                          Text(
                                            multiPrintList[index].title,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.black,
                                              fontSize: 15.fontSize,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            multiPrintList[index].heightWidth,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.black,
                                              fontSize: 11.fontSize,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   // AD
              //   margin:
              //       const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
              //   height: 50,
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(10.0),
              //   decoration: BoxDecoration(
              //     // borderRadius: BorderRadius.circular(30),
              //     color: AppColor.adColor.withOpacity(0.5),
              //     boxShadow: const [
              //       BoxShadow(
              //         color: Colors.grey,
              //       ),
              //     ],
              //   ),
              //   child: const Align(
              //     alignment: Alignment.center,
              //     child: Text(
              //       "AD",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 14,
              //         fontFamily: 'Poppins',
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // )
              if (_isAdLoaded && adConfig.bannerCollapsible)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                              _isAdCollapsed ? Icons.expand_more : Icons.close),
                          onPressed: _toggleAdVisibility,
                        ),
                      ],
                    ),
                    AnimatedBuilder(
                      animation: _heightAnimation,
                      builder: (context, child) {
                        return SizedBox(
                          height: _heightAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        // color: AppColor.adColor.withOpacity(0.5),
                        color: Colors.grey,
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Column twoSquares(int index) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10.h),
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.06,
          color: multiPrintList[index].isSelected
              ? AppColor.skyBlue
              : AppColor.borderColor,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.06,
          color: multiPrintList[index].isSelected
              ? AppColor.skyBlue
              : AppColor.borderColor,
        ),
      ],
    );
  }

  Row fourSquares(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.h),
              width: 50.w,
              height: 50.h,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
            Container(
              width: 50.w,
              height: 50.h,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
          ],
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.h, left: 10.w),
              width: 50.w,
              height: 50.h,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
            Container(
              margin: EdgeInsets.only(left: 10.w),
              width: 50.w,
              height: 50.h,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
          ],
        ),
      ],
    );
  }

  Column threeSquares(int index) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10.h),
          width: 100.w,
          height: 30.h,
          color: multiPrintList[index].isSelected
              ? AppColor.skyBlue
              : AppColor.borderColor,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10.h),
          width: 100.w,
          height: 30.h,
          color: multiPrintList[index].isSelected
              ? AppColor.skyBlue
              : AppColor.borderColor,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10.h),
          width: 100.w,
          height: 30.h,
          color: multiPrintList[index].isSelected
              ? AppColor.skyBlue
              : AppColor.borderColor,
        ),
      ],
    );
  }

  Row fourCircles(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: multiPrintList[index].isSelected
                    ? AppColor.skyBlue
                    : AppColor.borderColor,
              ),
              margin: EdgeInsets.only(bottom: 10.h),
              width: 50.w,
              height: 50.h,
              // color: AppColor.blueColor,
            ),
            Container(
              decoration: BoxDecoration(
                color: multiPrintList[index].isSelected
                    ? AppColor.skyBlue
                    : AppColor.borderColor,
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(bottom: 10.h),
              width: 50.w,
              height: 50.h,
              // color: AppColor.blueColor,
            ),
          ],
        ),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: multiPrintList[index].isSelected
                    ? AppColor.skyBlue
                    : AppColor.borderColor,
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(bottom: 10.h, left: 10.w),
              width: 50.w,
              height: 50.h,
              // color: AppColor.blueColor,
            ),
            Container(
              decoration: BoxDecoration(
                color: multiPrintList[index].isSelected
                    ? AppColor.skyBlue
                    : AppColor.borderColor,
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(bottom: 10.h, left: 10.w),
              width: 50.w,
              height: 50.h,
              // color: AppColor.blueColor,
            ),
          ],
        ),
      ],
    );
  }

  Column sixSquares(int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.h),
              width: 50.w,
              height: 30.h,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.h, left: 10.w),
              width: 50.w,
              height: 30.h,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.h),
              width: 50.w,
              height: 30.h,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.h, left: 10.w),
              width: 50.w,
              height: 30.h,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.h),
              width: 50.w,
              height: 30.h,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.h, left: 10.w),
              width: 50.w,
              height: 30.h,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
          ],
        ),
      ],
    );
  }

  Column eightSquares(int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.03,
              // width: 50,
              // height: 30,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8, left: 10),
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.03,
              // width: 50,
              // height: 30,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.03,
              // width: 50,
              // height: 30,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8, left: 10),
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.03,
              // width: 50,
              // height: 30,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.03,
              // width: 50,
              // height: 30,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8, left: 10),
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.03,
              // width: 50,
              // height: 30,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // margin: EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.03,
              // width: 50,
              // height: 30,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.03,
              // width: 50,
              // height: 30,
              color: multiPrintList[index].isSelected
                  ? AppColor.skyBlue
                  : AppColor.borderColor,
            ),
          ],
        ),
      ],
    );
  }
}
