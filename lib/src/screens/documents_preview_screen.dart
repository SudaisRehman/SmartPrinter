import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printer_app/src/connect_ui.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/widgets/ShimmerAd/ShimmerAd.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../database/app_database.dart';
import '../utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DocumentsPreviewScreen extends StatefulWidget {
  final String picture;
  final bool fromScanScreen;

  const DocumentsPreviewScreen({
    super.key,
    required this.picture,
    this.fromScanScreen = false,
  });

  @override
  _DocumentsPreviewScreenState createState() => _DocumentsPreviewScreenState();
}

class _DocumentsPreviewScreenState extends State<DocumentsPreviewScreen> {
  List<String> storedImagePaths = [];
  File? croppedFile;
  bool isPrinterConnected = false;
  AppDatabase noteDatabase = AppDatabase.instance;
  late BannerAd bannerad;
  bool _isbannerAdLoaded = false;
  @override
  void initState() {
    super.initState();
    checkPrinterInDB();
    loadBannerAd();
    widget.fromScanScreen ? _storeImages() : null;
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

  void loadBannerAd() async {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    // final AdSize? adaptiveSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
    //   MediaQuery.of(context).size.width.toInt(),

    // );
    bannerad = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: adConfig.bannerScandocId,
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

  Future<void> _storeImages() async {
    // Store the images in local storage
    List<String> paths = [];

    final file = File(widget.picture);
    final savedPath = await saveImageToLocalDirectory(file);
    paths.add(savedPath);

    setState(() {
      storedImagePaths = paths; // Update state with the stored paths
    });
  }

  Future<String> saveImageToLocalDirectory(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${directory.path}/$fileName';
    final newImage = await image.copy(filePath);
    return newImage.path;
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = Provider.of<AdConfigProvider>(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
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
          localization.preview,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20.fontSize,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    File? newCroppedFile = await _cropImage(
                      croppedFile?.path ?? widget.picture,
                      localization: localization,
                    );
                    if (newCroppedFile != null) {
                      setState(() {
                        croppedFile = newCroppedFile;
                      });
                    }
                  },
                  child: Container(
                    width: 100.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff17BDD3),
                    ),
                    child: Center(
                      child: Text(
                        localization.edit,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.fontSize,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    croppedFile ?? File(widget.picture),
                    // Show updated image or original
                    fit: BoxFit.cover,
                    height: 350.h,
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    if (isPrinterConnected) {
                      _printImage(localization: localization);
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
                _isbannerAdLoaded && adConfig.bannerScandoc
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
                    : adConfig.bannerScandoc
                        ? ShimmerLoading(height: 250, width: double.infinity)
                        : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to handle printing the image
  Future<void> _printImage({required AppLocalizations localization}) async {
    if (croppedFile != null || widget.picture.isNotEmpty) {
      final imageFile = croppedFile ?? File(widget.picture);

      // Trigger the print dialog
      await Printing.layoutPdf(onLayout: (format) async {
        final doc = pw.Document();
        final image = await imageFile.readAsBytes();
        doc.addPage(pw.Page(
          build: (pw.Context context) {
            return pw.Image(pw.MemoryImage(image));
          },
        ));
        return doc.save();
      });
    } else {
      // Handle case where no image is available for printing
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localization.noImageToPrint,
            style: TextStyle(
              fontSize: 13.fontSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  Future<File?> _cropImage(String imagePath,
      {required AppLocalizations localization}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: localization.editImage,
          backgroundColor: Colors.grey,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
          activeControlsWidgetColor: Colors.blue,
        ),
      ],
    );

    return croppedFile != null ? File(croppedFile.path) : null;
  }
}
