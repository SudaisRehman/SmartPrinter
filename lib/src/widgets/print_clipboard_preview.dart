import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printer_app/src/utils/colors.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../connect_ui.dart';
import '../database/app_database.dart';

class PrintClipboardPreviewWidget extends StatefulWidget {
  final Map<String, String> clipboardNote;

  const PrintClipboardPreviewWidget({
    Key? key,
    required this.clipboardNote,
  }) : super(key: key);

  @override
  State<PrintClipboardPreviewWidget> createState() =>
      _PrintClipboardPreviewWidgetState();
}

class _PrintClipboardPreviewWidgetState
    extends State<PrintClipboardPreviewWidget> {
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

  Future<void> _printDocument() async {
    // Load a font from assets (e.g., Open Sans)
    final ByteData fontData =
        await rootBundle.load('fonts/opensans-medium.ttf');
    final pw.Font ttf = pw.Font.ttf(fontData);

    // Create a PDF document
    final pdf = pw.Document();

    // Ensure the content is not empty
    final content = widget.clipboardNote['text'];
    if (content == null || content.isEmpty) {
      print('No content available to print.');
      return; // Exit if there's no content to print
    }

    // Add a page to the PDF with only the content
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(16.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Use Noto Sans for content to ensure better Unicode support
              pw.Text(
                content, // Use the retrieved content
                style: pw.TextStyle(
                  fontSize: 14,
                  font: ttf,
                ),
                maxLines: null, // Allow multiple lines for text
              ),
            ],
          ),
        ),
      ),
    );

    // Print the PDF document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          centerTitle: true,
          title: Text(
            localization.previewClipboardNote,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20.fontSize,
              color: AppColor.blackColor,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the text content in the preview
                    Text(
                      widget.clipboardNote['text']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.fontSize,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Fixed button at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (isPrinterConnected) {
                    _printDocument();
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.bluish,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Print',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.fontSize,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
