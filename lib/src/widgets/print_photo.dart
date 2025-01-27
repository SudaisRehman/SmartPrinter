// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:printer_app/Constants/Constant.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/widgets/ShimmerAd/ShimmerAd.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../connect_ui.dart';
import '../database/app_database.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintPhotoWidget extends StatefulWidget {
  // whats the usage of 'final' before data_type
  final String title;
  final List<XFile>? mediaFileList;
  final String? pdfFilePath;

  // Named constructor for photoList
  const PrintPhotoWidget.withPhotos({
    super.key,
    required this.title,
    required this.mediaFileList,
  }) : pdfFilePath = null;

  // Named constructor for pdfFilePath
  const PrintPhotoWidget.withPdf({
    super.key,
    required this.title,
    required this.pdfFilePath,
  }) : mediaFileList = null;

  @override
  State<PrintPhotoWidget> createState() => _PrintPhotoWidgetState();
}

class _PrintPhotoWidgetState extends State<PrintPhotoWidget> {
  //
  // bool isEditClicked = false;
  bool isPrinterConnected = false;
  AppDatabase noteDatabase = AppDatabase.instance;
  String editTitle = "Edit";
  CroppedFile? _croppedFile;

  @override
  void initState() {
    super.initState();
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    checkPrinterInDB();

    super.initState();
    // if (adProvider.bannerGotoGalleryScreen){
    print("adConfig.bannerPhoto : ${adConfig.bannerPhoto}");
    if (adConfig.bannerPhoto) {
      loadBannerAd();
    }
    // loadBannerAd();
    // }
  }

  late BannerAd bannerad;
  bool _isbannerAdLoaded = false;

  @override
  void dispose() {
    bannerad.dispose();
    super.dispose();
  }

  void loadBannerAd() async {
    // final AdSize? adaptiveSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
    //   MediaQuery.of(context).size.width.toInt(),

    // );
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    bannerad = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: adConfig.bannerPhotoId,
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

  Future<void> _printPdf() async {
    try {
      final doc = pw.Document();
      var photoOrPdf = widget.pdfFilePath ?? widget.mediaFileList![0].path;
      var photoBytes = await File(photoOrPdf).readAsBytes();
      final pageFormat = PdfPageFormat.a4;

      // doc.addPage(pw.Page(
      //     pageFormat: PdfPageFormat.a4,
      //     build: (pw.Context context) {
      //       return pw.Center(
      //         child: pw.Text('Hello Jimmy'),
      //       );
      //     }));

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => photoBytes,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _printPhoto(BuildContext ctx) async {
    try {
      final doc = pw.Document();
      var photoOrPdf = widget.pdfFilePath ?? widget.mediaFileList![0].path;
      var photoBytes = await File(photoOrPdf).readAsBytes();
      final pageFormat = PdfPageFormat.a4;

      doc.addPage(pw.Page(
          pageFormat: pageFormat,
          // orientation: pw.PageOrientation.portrait,
          build: (pw.Context context) {
            // return pw.Center(
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Image(
                // pw.MemoryImage(_imageBytes),
                pw.MemoryImage(photoBytes),
                // width: pageFormat.height - 20,
                // fit: pw.BoxFit.fitWidth,
              ),
            );
          }));

      // 打印
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
      );
    } catch (e) {
      debugPrint("Error printing photo $e");
    }
  }

// Future<void> _printPdf() async {
//     try {
//       final doc = pw.Document();
//       var photoOrPdf = widget.mediaFileList![0].path;
//       var photoBytes = await File(photoOrPdf).readAsBytes();
//       final pageFormat = PdfPageFormat.a4;

  Future<void> _cropImage() async {
    // if (_pickedFile != null) {
    if (widget.mediaFileList != null && widget.mediaFileList!.isNotEmpty) {
      final croppedFile = await ImageCropper().cropImage(
        // sourcePath: _pickedFile!.path,
        sourcePath: widget.mediaFileList![0].path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColor.menuColor,
            activeControlsWidgetColor: AppColor.menuColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
          ),
          // WebUiSettings(
          //   context: context,
          //   presentStyle: WebPresentStyle.dialog,
          //   size: const CropperSize(
          //     width: 520,
          //     height: 520,
          //   ),
          // ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  PDFView _previewPDF(String path) {
    return PDFView(
      filePath: path,
      fitEachPage: true,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
      backgroundColor: Colors.grey,
      onRender: (_pages) {
        setState(() {
          // pages = _pages;
          // isReady = true;
        });
      },
      onError: (error) {
        print(error.toString());
      },
      onPageError: (page, error) {
        print('$page: ${error.toString()}');
      },
      onViewCreated: (PDFViewController pdfViewController) {
        // _controller.complete(pdfViewController);
      },
      // onPageChanged: (int page, int total) {
      //   print('page change: $page/$total');
      // },
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
      // } else if (_pickedFile != null) {
    } else if (widget.mediaFileList != null &&
        widget.mediaFileList!.isNotEmpty) {
      final path = widget.mediaFileList![0].path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    final localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 15.w,
                        right: 15.w,
                        bottom: 15.h,
                      ),
                      child: Row(
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
                                size: 20.iconSize,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              localization.preview,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20.fontSize,
                              ),
                            ),
                          ),
                          SizedBox(width: 30.w),
                        ],
                      ),
                    ),
                    // Edit button
                    Visibility(
                      visible: widget.mediaFileList != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Preview.
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: InkWell(
                              onTap: () {
                                _cropImage();
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  right: 10.w,
                                  top: 8.h,
                                  bottom: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.menuColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  editTitle,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.fontSize,
                                    color: AppColor.whiteColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // preview
                    if (widget.mediaFileList != null)
                      _image()
                    else
                      Center(
                        child: SizedBox(
                          height: 600,
                          width: double.infinity,
                          child: _previewPDF(widget.pdfFilePath!),
                        ),
                      ),
                    // print image button
                    Row(
                      // Print button
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 15.h,
                            bottom: 15.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.menuColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () async {
                              print("isPrinterConnected : $isPrinterConnected");
                              if (isPrinterConnected) {
                                // print photo...
                                widget.pdfFilePath == null
                                    ? _printPhoto(context)
                                    : _printPdf();
                              } else {
                                /*
                              // Start the flow by navigating to ConnectUiWidget
                              final result = await Navigator.pushNamed(
                                  context, 'ConnectUiWidget');

                              // Check if the result indicates the printer was connected
                              if (result == "printer connected") {
                                print('Printer connection status: $result');
                                // Update UI or perform any additional actions here
                              }
                              */

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ConnectUiWidget(),
                                  ),
                                ).then((value) {
                                  setState(() {});
                                });
                                /* OLD CODE */
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 8,
                                bottom: 8,
                              ),
                              child: Row(children: [
                                Container(
                                    margin: EdgeInsets.only(right: 8, left: 0),
                                    child: Image.asset(
                                      'icons/icon_print_outline.webp',
                                      height: 30,
                                      width: 30,
                                      color: Colors.white,
                                    )),
                                Ink(
                                  child: Text(
                                    "${localization.print} ${widget.title}",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16.fontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _isbannerAdLoaded && adConfig.bannerPhoto
                        ? Container(
                            margin: EdgeInsets.only(
                              top: 3,
                            ),
                            // padding: EdgeInsets.only(
                            //   left: 5,
                            //   right: 5,
                            //   top: 5,
                            //   bottom: 5,
                            // ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 133, 137,
                                    145), // You can set any color for the border
                                width: 1.0, // Set the width of the border
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: bannerad.size.height.toDouble(),
                            child: AdWidget(ad: bannerad),
                          )
                        : adConfig.bannerPhoto
                            ? ShimmerLoading(
                                height: 300,
                                width: double.infinity,
                              )
                            : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
