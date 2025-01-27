import 'dart:async';
import 'dart:typed_data';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../connect_ui.dart';
import '../database/app_database.dart';

class PrintEmailsScreen extends StatefulWidget {
  final String urlString;

  const PrintEmailsScreen({super.key, required this.urlString});

  @override
  PrintEmailsScreenState createState() => PrintEmailsScreenState();
}

class PrintEmailsScreenState extends State<PrintEmailsScreen> {
  List<Uint8List> capturedScreenshots = [];
  Uint8List? capturedScreen;
  final GlobalKey _globalKey = GlobalKey();
  bool isCapturing = false;
  bool isPageLoaded = false;
  String currentUrl = '';
  late InAppWebViewController webViewController;
  bool isConnected = true;
  StreamSubscription? internetConnectionStreamSubs;
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
        print("printerList : ${printerList.length}");
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Print',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
                        url: WebUri(widget.urlString),
                      ),
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      // onLoadStop: (controller, url) async {
                      //   setState(() {
                      //     isPageLoaded = true;
                      //   });
                      // },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        if (isPrinterConnected) {
                          captureScreenshot(
                            errorPrintingDoc: 'Error printing',
                            errorCapturingScreenshot:
                                'Error capturing screenshot',
                            failedToCaptureScreenshot:
                                'Failed to capture screenshot',
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
                        height: 40,
                        width: 200,
                        margin: EdgeInsets.only(bottom: 15),
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
                              width: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Print Image',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
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
                        const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff4585EE),
                          ),
                        ),
                      ],
                    ),
                ],
              )
            : Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'icons/new/wifi_icon.webp',
                        width: 45,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No WiFi or Data Network',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'This device is not connected to WiFi or Data Network right now. Make sure it’s connected so that you can use the smart printer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () => AppSettings.openAppSettings(
                            type: AppSettingsType.wifi),
                        child: Container(
                          height: 35,
                          width: 250,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff17BDD3),
                          ),
                          child: Center(
                            child: Text(
                              'Connect to WiFi or Data Network',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
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
      //     SnackBar(content: Text('Please wait for the page to load fully.')),
      //   );
      // }
    } catch (e) {
      // General error handling
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$errorCapturingScreenshot $e'),
      ));
    } finally {
      setState(() {
        isCapturing = false;
      });
    }
  }
}
