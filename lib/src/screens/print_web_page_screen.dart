import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pdf/pdf.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../connect_ui.dart';
import '../database/app_database.dart';
import '../utils/colors.dart';

class PrintWebPageScreen extends StatefulWidget {
  const PrintWebPageScreen({super.key});

  @override
  PrintWebPageScreenState createState() => PrintWebPageScreenState();
}

class PrintWebPageScreenState extends State<PrintWebPageScreen> {
  List<Uint8List> capturedScreenshots = [];
  Uint8List? capturedScreen;
  final GlobalKey _globalKey = GlobalKey();
  bool isCapturing = false;
  bool isPageLoaded = false;
  String currentUrl = '';
  late InAppWebViewController webViewController;
  bool isConnected = true;
  StreamSubscription? internetConnectionStreamSubs;

  // Scanning Printers
  bool isPrinterConnected = false;
  AppDatabase noteDatabase = AppDatabase.instance;

  @override
  void initState() {
    checkPrinterInDB();
    internetConnectionStreamSubs =
        InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnected = true;
          });

          break;

        case InternetStatus.disconnected:
          setState(() {
            isConnected = false;
          });
          break;

        default:
          setState(() {
            isConnected = false;
          });
          break;
      }
    });
    super.initState();
  }

  void checkPrinterInDB() {
    noteDatabase.readAll().then((printerList) {
      setState(() {
        // _printListDataBase = printerList;
        log("printerList : ${printerList.length}");
        if (printerList.isEmpty) {
          isPrinterConnected = false;
        } else {
          isPrinterConnected = true;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    internetConnectionStreamSubs?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            localization.print,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20.fontSize,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: isConnected
            ? Stack(
                children: [
                  RepaintBoundary(
                    key: _globalKey,
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri('https://www.google.com'),
                      ),
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStop: (controller, url) async {
                        setState(() {
                          isPageLoaded = true;
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        print("isPrinterConnected : $isPrinterConnected");
                        if (isPrinterConnected) {
                          captureScreenshot(
                            errorPrintingDoc: localization.errorWhilePrinting,
                            errorCapturingScreenshot:
                                localization.errorWhilePrinting,
                            failedToCaptureScreenshot:
                                localization.failedToCaptureScreenshot,
                            localization: localization,
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ConnectUiWidget(),
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        }
                      },
                      child: Container(
                        width: 200.w,
                        height: 40.h,
                        margin: EdgeInsets.only(bottom: 15.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff17BDD3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'icons/new/bold_print_icon.webp',
                              color: Colors.white,
                              width: 25.w,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              localization.printImage,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 15.fontSize,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isCapturing)
                    Stack(
                      children: [
                        ModalBarrier(
                          color: Colors.black.withOpacity(0.3),
                          dismissible: false,
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            color: AppColor.mainBluishColor,
                          ),
                        ),
                      ],
                    ),
                ],
              )
            : Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40.w),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'icons/new/wifi_icon.webp',
                        width: 45.w,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        localization.noWifiOrDataNetwork,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.fontSize,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        localization.thisDeviceIsNotConnectedToWifi,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.fontSize,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      InkWell(
                        onTap: () {
                          AppSettings.openAppSettings(
                            type: AppSettingsType.wifi,
                          );
                        },
                        child: Container(
                          width: 250.w,
                          height: 35.h,
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff17BDD3),
                          ),
                          child: Center(
                            child: Text(
                              localization.connectToWifiOrData,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 13.fontSize,
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
      ),
    );
  }

  Future<void> printCapturedDocument(List<Uint8List> imageBytesList,
      {required String errorPrintingDoc}) async {
    try {
      final pdf = pw.Document();
      for (final imageBytes in imageBytesList) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(
                  pw.MemoryImage(imageBytes),
                  width: PdfPageFormat.a4.width,
                  height: PdfPageFormat.a4.height,
                ),
              );
            },
          ),
        );
      }
      final Uint8List pdfBytes = await pdf.save();
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    } catch (e) {
      // Error handling for print failures
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$errorPrintingDoc $e'),
      ));
    }
  }

  Future<void> captureScreenshot({
    required String errorPrintingDoc,
    required String failedToCaptureScreenshot,
    required String errorCapturingScreenshot,
    required AppLocalizations localization,
  }) async {
    setState(() {
      isCapturing = true;
    });

    try {
      // Ensure page is fully loaded before capturing
      // if (isPageLoaded) {
      // Take screenshot from the WebView as a Uint8List
      Uint8List? screenshotBytes = await webViewController.takeScreenshot();
      if (screenshotBytes != null) {
        capturedScreenshots.add(screenshotBytes);

        await printCapturedDocument(capturedScreenshots,
            errorPrintingDoc: errorPrintingDoc);
        capturedScreenshots.clear(); // Clear list to avoid memory overflow
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failedToCaptureScreenshot)),
        );
      }
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(localization.pleaseWaitForThePageToLoad)),
      //   );
      // }
    } catch (e) {
      // General error handling
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$errorCapturingScreenshot $e')));
    } finally {
      setState(() {
        isCapturing = false;
      });
    }
  }
}
