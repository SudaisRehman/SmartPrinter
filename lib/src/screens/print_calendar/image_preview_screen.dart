import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../dummy_ad_container.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imagePath;

  const ImagePreviewScreen({super.key, required this.imagePath});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Preview',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: widget.imagePath.isNotEmpty
                    ? Image.asset(widget.imagePath)
                    : Center(
                        child: Text(
                          'No image selected',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 50),
              DummyAdContainer(),
              InkWell(
                onTap: () => _printImage(),
                child: Container(
                  height: 40,
                  width: 200,
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _printImage() async {
    if (widget.imagePath.isNotEmpty) {
      try {
        // Load image as bytes from assets
        final imageBytes = await rootBundle.load(widget.imagePath);
        final image = imageBytes.buffer.asUint8List();

        // Trigger the print dialog
        await Printing.layoutPdf(onLayout: (format) async {
          final doc = pw.Document();
          doc.addPage(pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(pw.MemoryImage(image)),
              );
            },
          ));
          return doc.save();
        });
      } catch (e) {
        // Handle file not found or loading error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading image: $e')),
        );
      }
    } else {
      // Handle case where no image is available for printing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image to print')),
      );
    }
  }


  // Future<void> _printImage() async {
  //   if (widget.imagePath.isNotEmpty) {
  //     final imageFile = File(widget.imagePath);
  //
  //     // Trigger the print dialog
  //     await Printing.layoutPdf(onLayout: (format) async {
  //       final doc = pw.Document();
  //       final image = await imageFile.readAsBytes(); // Read image bytes
  //       doc.addPage(pw.Page(
  //         build: (pw.Context context) {
  //           return pw.Center(
  //             child: pw.Image(pw.MemoryImage(image)),
  //           );
  //         },
  //       ));
  //       return doc.save();
  //     });
  //   } else {
  //     // Handle case where no image is available for printing
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No image to print')),
  //     );
  //   }
  // }
}
