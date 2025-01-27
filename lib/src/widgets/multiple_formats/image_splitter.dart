import 'dart:io';

import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/services/admob_easy_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart'; // Make sure to include the image package in your pubspec.yaml

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img; // Import for image manipulation
import 'package:image_picker/image_picker.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/widgets/ShimmerAd/ShimmerAd.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../connect_ui.dart';
import '../../database/app_database.dart';
import '../../utils/colors.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class ImageSplitter extends StatefulWidget {
  final int rows;
  final int columns;
  final double horizontalSpace;
  final double padding;

  const ImageSplitter({
    Key? key,
    required this.rows,
    required this.columns,
    this.horizontalSpace = 0.0,
    this.padding = 4.0,
  }) : super(key: key);

  @override
  State<ImageSplitter> createState() => _ImageSplitterState();
}

class _ImageSplitterState extends State<ImageSplitter> {
  List<Image> imageList = [];
  XFile? selectedImage;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _gridKey = GlobalKey(); // Add key for RepaintBoundary
  bool isPrinterConnected = false;
  AppDatabase noteDatabase = AppDatabase.instance;
  bool isNativeAdLoaded = false;

  @override
  void initState() {
    super.initState();
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    checkPrinterInDB();
    _loadDefaultImage();
    if (adConfig.nativePoster && !isNativeAdLoaded) {
      // _initializeNativeAd();

      AdmobEasy.instance.initialize(
        androidNativeAdID: adConfig.nativePosterId, // Test Ad ID
      );
      isNativeAdLoaded = true;
    }
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

  // Load default image from assets and split it
  Future<void> _loadDefaultImage() async {
    ByteData byteData = await rootBundle
        .load('icons/splitter_default.webp'); // Provide your image path here
    Uint8List bytes = byteData.buffer.asUint8List();
    _splitAndSetImage(bytes);
  }

  // Method to pick an image from the gallery on tap
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
      Uint8List bytes = await File(selectedImage!.path).readAsBytes();
      _splitAndSetImage(bytes);
    }
  }

  // Split image and update the image list
  void _splitAndSetImage(Uint8List bytes) {
    List<Image> parts = splitImage(bytes, widget.rows, widget.columns);
    setState(() {
      imageList = parts;
    });
  }

  // Function to capture and print the split image grid
  Future<void> printImageGrid() async {
    try {
      RenderRepaintBoundary boundary =
          _gridKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final pdf = pw.Document();
      final imageMemory = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            // A4 dimensions in points (1 point = 1/72 inch)
            final pdfWidth = PdfPageFormat.a4.width;
            final pdfHeight = PdfPageFormat.a4.height;

            // Calculate the aspect ratio of the image
            double aspectRatio = image.width / image.height;

            // Determine the width and height to scale the image without cropping
            double scaledWidth, scaledHeight;
            if (aspectRatio > pdfWidth / pdfHeight) {
              // Width is limiting factor
              scaledWidth = pdfWidth;
              scaledHeight = pdfWidth / aspectRatio;
            } else {
              // Height is limiting factor
              scaledHeight = pdfHeight;
              scaledWidth = pdfHeight * aspectRatio;
            }

            return pw.Container(
              width: pdfWidth,
              height: pdfHeight,
              child: pw.Center(
                child: pw.Image(
                  imageMemory,
                  width: scaledWidth,
                  height: scaledHeight,
                  fit: pw.BoxFit.contain,
                ),
              ),
            );
          },
          pageFormat: PdfPageFormat.a4,
        ),
      );
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      print("Error capturing image for print: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 15.0, bottom: 10.0, top: 10.0),
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
                      child: Container(
                        margin: const EdgeInsets.only(right: 40),
                        child: const Text(
                          textAlign: TextAlign.center,
                          "Preview",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tap on image container to pick a new image
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Padding(
                          padding: EdgeInsets.all(widget.padding),
                          child: RepaintBoundary(
                            key: _gridKey, // Add RepaintBoundary with key
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: widget.columns,
                                mainAxisSpacing: widget.padding,
                                crossAxisSpacing: widget.horizontalSpace,
                                childAspectRatio: 1, // Keep the images square
                              ),
                              itemCount: imageList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.all(widget.padding),
                                  child: imageList.isNotEmpty
                                      ? imageList[index]
                                      : Center(
                                          child: Text(
                                            "Loading...",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 15,
                            bottom: 15,
                            right: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 8,
                                bottom: 8,
                              ),
                              child: Text(
                                "Change Image",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
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
                                printImageGrid();
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
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 8,
                                bottom: 8,
                              ),
                              child: Text(
                                "Print Image",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // AD
                    // Container(
                    //   margin: const EdgeInsets.only(
                    //       top: 0, bottom: 0, left: 0, right: 0),
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
                    // Spacer(),
                    adConfig.nativePoster && isNativeAdLoaded
                        ? AdmobEasyNative.smallTemplate(
                            minWidth: 320,
                            minHeight: 50,
                            maxWidth: 400,
                            maxHeight: 85,
                            onAdClicked: (ad) => print("Ad Clicked"),
                            onAdImpression: (ad) =>
                                print("Ad Impression Logged"),
                            onAdClosed: (ad) => print("Ad Closed"),
                          )
                        : adConfig.nativePoster
                            ? ShimmerLoadingBanner(
                                height: 100, width: 400) // Shimmer effect
                            : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to split the image into parts
List<Image> splitImage(Uint8List input, int rows, int columns) {
  img.Image? image = img.decodeImage(input);

  // Calculate width and height for each part
  int width = (image!.width / columns).round();
  int height = (image.height / rows).round();

  // Adjust for rounding issues to fit exact image size
  int lastColumnWidth = image.width - (width * (columns - 1));
  int lastRowHeight = image.height - (height * (rows - 1));

  // Split the image into parts
  List<img.Image> parts = [];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < columns; j++) {
      int cropWidth = (j == columns - 1) ? lastColumnWidth : width;
      int cropHeight = (i == rows - 1) ? lastRowHeight : height;

      parts.add(img.copyCrop(image,
          x: j * width, y: i * height, width: cropWidth, height: cropHeight));
    }
  }

  // Convert parts into Image widgets
  return parts.map((singlePart) {
    return Image.memory(
      Uint8List.fromList(img.encodePng(singlePart)),
      fit: BoxFit.fill,
    );
  }).toList();
}

// Uint8List
// img.copyCrop(image,x: j * width,y: i * height, width: width, height: height)
//   img.Image part = img.copyCrop(image,x:  x,y:  y,width:  cropWidth,height:  cropHeight);
