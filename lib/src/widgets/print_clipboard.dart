import 'package:admob_easy/ads/admob_easy.dart';
import 'package:admob_easy/ads/services/admob_easy_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/widgets/ShimmerAd/ShimmerAd.dart';
import 'package:printer_app/src/widgets/print_clipboard_preview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/colors.dart';

class PrintClipboardWidget extends StatefulWidget {
  @override
  _PrintClipboardWidgetState createState() => _PrintClipboardWidgetState();
}

class _PrintClipboardWidgetState extends State<PrintClipboardWidget> {
  bool isNativeAdLoaded = false; // Tracks ad loading state
  @override
  void initState() {
    super.initState();
    _initializeNativeAd();
  }

  void _initializeNativeAd() async {
    AdmobEasy.instance.initialize(
      androidNativeAdID: 'ca-app-pub-3940256099942544/2247696110', // Test Ad ID
    );

    // Simulating ad load delay (Ad loading happens asynchronously)
    await Future.delayed(const Duration(seconds: 1));

    // Update the state to simulate the ad being loaded
    if (mounted) {
      setState(() {
        isNativeAdLoaded = true; // Simulating successful ad load
      });
    }
    print('Native Ad loaded');
  }

  List<Map<String, String>> clipboardNotes = [];
  String errorMessage = '';

  Future<void> pasteFromClipboard(
      {required AppLocalizations localization}) async {
    try {
      final clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData == null || clipboardData.text!.isEmpty) {
        setState(() {
          errorMessage = localization.noSaveClipboard;
        });
      } else {
        // Check if the clipboard text already exists in the list
        bool alreadyExists =
            clipboardNotes.any((note) => note['text'] == clipboardData.text);

        if (alreadyExists) {
          // Show toast if the clipboard text already exists
          Fluttertoast.showToast(
            msg: localization.alreadyExitsInTheList,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else {
          // Clear any previous error message
          setState(() {
            errorMessage = ''; // Clear error if we get valid clipboard text
            final dateAdded = DateFormat('dd/MM/yyyy').format(DateTime.now());
            clipboardNotes.add({
              'title': 'clipboard_${clipboardNotes.length + 1}',
              'date': dateAdded,
              'text': clipboardData.text!,
            });
          });
        }
      }
    } catch (e) {
      // Handle exceptions, if any
      setState(() {
        errorMessage = localization.failedToRetrieveClipboard;
      });
    }
  }

  void editNote(int index, {required AppLocalizations localization}) {
    // Assuming clipboardNotes[index] has a 'title' key for the title
    TextEditingController editController =
        TextEditingController(text: clipboardNotes[index]['title']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.whiteColor,
          title: Text(
            localization.editNoteTitle,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18.fontSize,
              color: AppColor.blackColor,
            ),
          ),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              hintText: localization.enterNewTitle,
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 15.fontSize,
                color: AppColor.blackColor,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Update the title instead of the text
                  clipboardNotes[index]['title'] = editController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                localization.save,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15.fontSize,
                  color: AppColor.blackColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localization.cancel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15.fontSize,
                  color: AppColor.blackColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void deleteNote(int index) {
    setState(() {
      clipboardNotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        centerTitle: true,
        title: Text(
          localization.printNotes,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20.fontSize,
            color: AppColor.blackColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: clipboardNotes.isEmpty
                  ? Center(
                      child: Text(
                        localization.noData,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 17.fontSize,
                          color: AppColor.blackColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: clipboardNotes.length,
                      itemBuilder: (context, index) {
                        final note = clipboardNotes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PrintClipboardPreviewWidget(
                                  clipboardNote: note,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            color: AppColor.whiteColor,
                            elevation: 2,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 70.w,
                                    height: 70.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      note['text']!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.fontSize,
                                        color: AppColor.blackColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          note['title']!,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.fontSize,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                        Text(
                                          note['date']!,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.fontSize,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    color: AppColor.whiteColor,
                                    onSelected: (value) {
                                      if (value == 'Edit') {
                                        editNote(
                                          index,
                                          localization: localization,
                                        );
                                      } else if (value == 'Delete') {
                                        deleteNote(index);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'Edit',
                                        child: Text(
                                          localization.edit,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.fontSize,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Delete',
                                        child: Text(
                                          localization.delete,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.fontSize,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                    child: Icon(Icons.more_vert),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => pasteFromClipboard(localization: localization),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.bluish,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  localization.pasteFromClipboard,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 15.fontSize,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            isNativeAdLoaded
                ? AdmobEasyNative.mediumTemplate(
                    minWidth: 320,
                    minHeight: 50,
                    maxWidth: 400,
                    maxHeight: 350,
                    onAdClicked: (ad) => print("Ad Clicked"),
                    onAdImpression: (ad) => print("Ad Impression Logged"),
                    onAdClosed: (ad) => print("Ad Closed"),
                  )
                : ShimmerLoadingBanner(
                    height: 320, width: 400), // Shimmer effect
          ],
        ),
      ),
    );
  }
}
