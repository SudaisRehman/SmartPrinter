import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:printer_app/Constants/Constant.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/providers/nav_bar_provider.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/widgets/ShimmerAd/ShimmerAd.dart';
import 'package:provider/provider.dart';
import '../models/print_menu_pojo.dart';
import '../models/scan_menu_pojo.dart';
import '../scanner/cunning_document_scanner.dart';
import '../screens/scanner/mobile_scanner_overlay.dart';
import '../utils/colors.dart';
import '../screens/documents_preview_screen.dart';
import '../screens/ocr_image_screen.dart';
import '../screens/view_documents_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScanDocumentWidget extends StatefulWidget {
  const ScanDocumentWidget({super.key});

  @override
  State<ScanDocumentWidget> createState() => _ScanDocumentWidgetState();
}

class _ScanDocumentWidgetState extends State<ScanDocumentWidget> {
  String _picture = '';
  List<String>? _scannedImages;
  String? extractedText;
  late List<ScanItem> documentTypeList = [];
  late List<PrintItem> dataDetectorList = [];

  @override
  void initState() {
    super.initState();
    // checkPrinterInDB();
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    super.initState();
    if (adConfig.bannerScan) {
      loadBannerAd();
    }
  }

  late BannerAd bannerad;
  bool _isbannerAdLoaded = false;

  @override
  void dispose() {
    bannerad.dispose();
    super.dispose();
  }

  void loadBannerAd() async {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    // final AdSize? adaptiveSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
    //   MediaQuery.of(context).size.width.toInt(),

    // );
    bannerad = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: adConfig.bannerScanId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isbannerAdLoaded = true;
          });
          print('Ad loaded: ${ad.adUnitId}');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
        },
      ),
      request: AdRequest(),
    );
    bannerad.load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localization = AppLocalizations.of(context)!;

    documentTypeList = [
      ScanItem(
        title: localization.scanDocument,
        iconName: "icons/icon_scan_document.webp",
      ),
      ScanItem(
        title: localization.viewDocument,
        iconName: "icons/icon_view_document.webp",
      ),
    ];

    dataDetectorList = [
      PrintItem(
        title: "${localization.qr}\n${localization.code}",
        startColor: const Color(0xFF947fe9),
        endColor: const Color(0xFFc4d0ff),
        iconName: "icons/icon_qr_code.webp",
      ),
      PrintItem(
        title: "${localization.barCode}\n${localization.scan}",
        startColor: const Color(0xFFca47eb),
        endColor: const Color(0xFFf19fff),
        iconName: "icons/icon_barcode_code.png",
      ),
      PrintItem(
        title: "${localization.ocr}\n${localization.image}",
        startColor: const Color(0xFFff9178),
        endColor: const Color(0xFFffd6c9),
        iconName: "icons/icon_ocr_code.webp",
      ),
    ];
  }

  Widget bigCircle = Positioned(
    top: -180.w,
    left: -110.h,
    child: Container(
      width: 450.w,
      height: 350.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          transform: GradientRotation(8),
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColor.lightBlueColor,
            Color(0xFF85f0ff),
          ],
        ),
      ),
    ),
  );

  Widget twoCircles = Positioned(
    top: 150.w,
    right: -20.h,
    child: Container(
      width: 150.w,
      height: 150.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFcbecf1),
          width: 15.w,
        ),
      ),
    ),
  );

  void onPressed() async {
    try {
      List<String>? pictures = await CunningDocumentScanner.getPictures(
            noOfPages: 1,
            isGalleryImportAllowed: false,
          ) ??
          [];

      if (!mounted) return;

      if (pictures.isNotEmpty) {
        setState(() {
          _picture = pictures[0];
          print("Pictures returned");
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentsPreviewScreen(
              picture: _picture,
              fromScanScreen: true,
            ),
          ),
        );
      } else {
        // Show a message or handle the case when no image is captured
        print("No pictures captured");
      }
    } catch (exception) {
      // Handle exception here
      print("Exception: $exception");
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$exception',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 13.fontSize,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  Future<void> ocrScannerOnPressed(
      {required AppLocalizations localization}) async {
    try {
      final images = await CunningDocumentScanner.getPictures(
        noOfPages: 1,
        isGalleryImportAllowed: false,
      );
      if (images != null && images.isNotEmpty) {
        setState(() {
          _scannedImages = images;
        });

        // Wait for text extraction and update the UI with the extracted text
        String? text = await _extractTextFromImage(_scannedImages![0]);
        setState(() {
          extractedText = text;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OCRTextScreen(
              extractedText: (extractedText == null || extractedText!.isEmpty)
                  ? localization.na
                  : extractedText,
            ),
          ),
        );
      }
    } catch (e) {
      // Handle errors (e.g., permission denied)
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 13.fontSize,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  Future<String> _extractTextFromImage(String imagePath) async {
    try {
      // Proceed with text recognition
      final inputImage = InputImage.fromFilePath(imagePath);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      await textRecognizer.close();
      List<TextBlock> textBlocks = recognizedText.blocks;

      StringBuffer extractedTextBuffer = StringBuffer();
      for (TextBlock block in textBlocks) {
        List<TextLine> lines = block.lines;
        lines.sort((a, b) {
          int verticalComparison =
              a.boundingBox.top.compareTo(b.boundingBox.top);
          if (verticalComparison != 0) return verticalComparison;
          return a.boundingBox.left.compareTo(b.boundingBox.left);
        });
        for (TextLine line in lines) {
          extractedTextBuffer.writeln(line.text);
        }
      }
      return extractedTextBuffer.toString();
    } catch (e) {
      // log('Error extracting text from image: $e');
      return 'Error extracting text';
    }
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    final navBarProvider = Provider.of<NavBarProvider>(context);
    final localization = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        navBarProvider.setNavBarIndex(0);
      },
      child: Stack(children: [
        bigCircle,
        twoCircles,
        Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 30.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localization.smartPrinterAndScanner,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.fontSize,
                  ),
                ),
                // Scan || View Documents.
                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // if (kDebugMode) {
                            onPressed();
                            print("open scanning ui");
                            // }
                          },
                          child: Container(
                            height: 100,
                            margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColor.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  documentTypeList[0].iconName,
                                  width: 50.w,
                                  height: 50.h,
                                ),
                                Text(
                                  documentTypeList[0].title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.fontSize,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(width: 20.w),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewDocumentsScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 100.h,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColor.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  documentTypeList[1].iconName,
                                  width: 50.w,
                                  height: 50.h,
                                ),
                                Text(
                                  documentTypeList[1].title,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 16.fontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // TODO pass the source to widget.
                // for (var picture in _pictures)
                //   Image.file(
                //     File(picture),
                //     width: double.infinity,
                //     height: 100,
                //   ),
                // Center(child: Text(result)),
                Container(
                    margin: EdgeInsets.only(top: 20.h),
                    child: Text(
                      localization.dataDetectors,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 16.fontSize,
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 0.0,
                      childAspectRatio: (1 / .66),
                    ),
                    itemCount: dataDetectorList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          switch (index) {
                            case 0:
                              // qrCodeOnPressed();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BarcodeScannerWithOverlay(),
                                ),
                              );
                            case 1:
                              // qrCodeOnPressed();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BarcodeScannerWithOverlay(),
                                ),
                              );
                            case 2:
                              ocrScannerOnPressed(localization: localization);
                          }
                        },
                        child: Container(
                          height: 60.h,
                          margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          // width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              transform: const GradientRotation(9),
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                dataDetectorList[index].startColor,
                                dataDetectorList[index].endColor,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dataDetectorList[index].title,
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 16.fontSize,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  dataDetectorList[index].iconName,
                                  width: 40.w,
                                  height: 40.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                _isbannerAdLoaded && adConfig.bannerScan
                    ? Padding(
                        padding: EdgeInsets.only(
                          bottom: 5,
                          top: 5,
                          left: 5,
                          right: 5,
                          // bottom: size.height * 0.005,
                          // left: size.width * 0.025,
                          // right: size.width * 0.025,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 3,
                          ),
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 5,
                            bottom: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 133, 137,
                                  145), // You can set any color for the border
                              width: 1.0, // Set the width of the border
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: bannerad.size.height.toDouble(),
                          child: AdWidget(ad: bannerad),
                        ),
                      )
                    : adConfig.bannerScan
                        ? ShimmerLoading(height: 250, width: double.infinity)
                        : Container(),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
