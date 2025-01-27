import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printer_app/Constants/Constant.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/utils/colors.dart';
import 'package:printer_app/src/widgets/ShimmerAd/ShimmerAd.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../connect_ui.dart';
import '../database/app_database.dart';

class PrinterNotes extends StatefulWidget {
  @override
  _PrinterNotesState createState() => _PrinterNotesState();
}

class _PrinterNotesState extends State<PrinterNotes> {
  final quill.QuillController _controller = quill.QuillController.basic();
  bool isPrinterConnected = false;
  AppDatabase noteDatabase = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    checkPrinterInDB();
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    super.initState();
    // if (adProvider.bannerGotoGalleryScreen){
    if (adConfig.bannerNotes) {
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
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    // final AdSize? adaptiveSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
    //   MediaQuery.of(context).size.width.toInt(),

    // );
    bannerad = BannerAd(
      size: AdSize.banner,
      adUnitId: adConfig.bannerNotesId,
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

  // Convert Quill document to PDF
  Future<void> _printNotes() async {
    final pdf = pw.Document();
    final docText = _controller.document.toPlainText();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Paragraph(
              text: docText,
              style: pw.TextStyle(fontSize: 12),
            ),
          ];
        },
      ),
    );

    // Print the PDF document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Column(
          children: [
            _isbannerAdLoaded && adConfig.bannerNotes
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
                : adConfig.bannerNotes
                    ? ShimmerLoadingBanner(height: 100, width: 300)
                    : Container(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 15.0, bottom: 10.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: const Text(
                      textAlign: TextAlign.center,
                      "Notes",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (isPrinterConnected) {
                          _printNotes();
                          ;
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
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Text(
                          "Print Notes",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: quill.QuillEditor(
                  controller: _controller,
                  focusNode: FocusNode(),
                  scrollController: ScrollController(),
                ),
              ),
            ),
            quill.QuillToolbar.simple(controller: _controller),
          ],
        ),
      ),
    );
  }
}
