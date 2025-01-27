import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printer_app/src/connect_ui.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'documents_preview_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewDocumentsScreen extends StatefulWidget {
  const ViewDocumentsScreen({super.key});

  @override
  _ViewDocumentsScreenState createState() => _ViewDocumentsScreenState();
}

class _ViewDocumentsScreenState extends State<ViewDocumentsScreen> {
  List<String> storedImagePaths = [];

  @override
  void initState() {
    super.initState();
    _fetchStoredImages();
  }

  Future<void> _fetchStoredImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory(directory.path);
    final files = imageDir.listSync();

    List<String> imagePaths = files
        .where((file) => file.path.endsWith('.jpg'))
        .map((file) => file.path)
        .toList();

    setState(() {
      storedImagePaths = imagePaths;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          localization.viewDocument,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20.fontSize,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: storedImagePaths.isEmpty
          ? Center(
              child: Text(
                localization.noImagesFound,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15.fontSize,
                  color: Colors.black,
                ),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              itemCount: storedImagePaths.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final imagePath = storedImagePaths[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DocumentsPreviewScreen(picture: imagePath),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
