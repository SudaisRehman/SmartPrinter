import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../connect_ui.dart';
import '../database/app_database.dart';

class OCRTextScreen extends StatefulWidget {
  final String? extractedText;

  const OCRTextScreen({super.key, required this.extractedText});

  @override
  State<OCRTextScreen> createState() => _OCRTextScreenState();
}

class _OCRTextScreenState extends State<OCRTextScreen> {
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            textAlign: TextAlign.center,
            localization.extractedText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20.fontSize,
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: SingleChildScrollView(
                child: Text(
                  widget.extractedText ?? localization.na,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.fontSize,
                    height: 1.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    if (isPrinterConnected) {
                      if (widget.extractedText != null &&
                          widget.extractedText != localization.na) {
                        printText(widget.extractedText!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              localization.extractedTextIsEmpty,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13.fontSize,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff17BDD3),
                    ),
                    child: Center(
                      child: Text(
                        localization.print,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 14.fontSize,
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
