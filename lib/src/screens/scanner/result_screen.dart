import 'dart:developer';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:printer_app/src/screens/scanner/qr_code_formats.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../connect_ui.dart';
import '../../database/app_database.dart';

class ResultScreenQrCode extends StatefulWidget {
  final Barcode barcode;

  const ResultScreenQrCode({super.key, required this.barcode});

  @override
  State<ResultScreenQrCode> createState() => _ResultScreenQrCodeState();
}

class _ResultScreenQrCodeState extends State<ResultScreenQrCode> {
  bool isPrinterConnected = false;
  AppDatabase noteDatabase = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    checkPrinterInDB();
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
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    String displayContent = '';
    String scanType = '';

    if (widget.barcode.rawValue != null) {
      log('barcode not null');

      String rawValue = widget.barcode.rawValue!;

      if (rawValue.startsWith('http://') || rawValue.startsWith('https://')) {
        // URL QR Code
        scanType = localization.url;
        displayContent = rawValue;
      } else if (rawValue.startsWith('BEGIN:VCARD')) {
        // vCard QR Code
        scanType = localization.vCard;
        displayContent = QrCodeFormats.formatVCard(rawValue);
      } else if (rawValue.startsWith('SMSTO:')) {
        // SMS QR Code
        scanType = localization.sms;
        displayContent = QrCodeFormats.formatSMS(rawValue);
      } else if (rawValue.contains('@') && !rawValue.startsWith('WIFI:')) {
        // Email QR Code (basic check for '@' symbol, excluding WiFi QR codes)
        scanType = localization.email;
        displayContent = QrCodeFormats.formatEmail(rawValue);
      } else if (rawValue.startsWith('WIFI:')) {
        // WiFi QR Code
        scanType = localization.wifi;
        displayContent = QrCodeFormats.formatWifiBarcode(rawValue);
      } else {
        scanType = localization.text;
        displayContent = rawValue;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            localization.scanResults,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20.fontSize,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                // Copy the text to clipboard
                Clipboard.setData(ClipboardData(text: displayContent));

                // Show a confirmation message
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      localization.textCopiedToClipboard,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.fontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.copy,
                color: Colors.blue,
                size: 20.iconSize,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${localization.resultType} : ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 17.fontSize,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          scanType,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 17.fontSize,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        displayContent,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.fontSize,
                          height: 1.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: GestureDetector(
                  onTap: () {
                    if (isPrinterConnected) {
                      printText(displayContent);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const ConnectUiWidget(),
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    }
                  },
                  child: Container(
                    width: 200.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff17BDD3),
                    ),
                    child: Center(
                      child: Text(
                        localization.print,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.fontSize,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void printText(String text) async {
    try {
      await Printing.layoutPdf(
        onLayout: (format) async => await generatePdf(text),
      );
    } catch (e) {
      log('Error while printing: $e');
    }
  }

  Future<Uint8List> generatePdf(String text) async {
    final pdf = pw.Document();
    const double fontSize = 15;
    const double pageWidth = 595.28; // A4 width in points
    const double pageHeight = 841.89; // A4 height in points
    const double padding = 20;

    final availableWidth = pageWidth - (padding * 2);
    final availableHeight = pageHeight - (padding * 2);

    // Split the text into multiple paragraphs for pagination
    final style = pw.TextStyle(fontSize: fontSize);
    final lines = text.split('\n');
    final lineHeight =
        fontSize * 1.2; // Estimate line height based on font size
    final maxLinesPerPage = (availableHeight / lineHeight).floor();

    int startIndex = 0;
    while (startIndex < lines.length) {
      // Get the lines for the current page
      final endIndex = (startIndex + maxLinesPerPage > lines.length)
          ? lines.length
          : startIndex + maxLinesPerPage;
      final pageText = lines.sublist(startIndex, endIndex).join('\n');

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(padding),
              child: pw.Text(
                pageText,
                style: style,
              ),
            );
          },
        ),
      );

      startIndex = endIndex; // Move to the next page
    }

    return Uint8List.fromList(await pdf.save());
  }
}
