import 'dart:async';
import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printer_app/src/utils/colors.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../connect_ui.dart';
import '../database/app_database.dart';

class TriviaService {
  final String baseUrl = 'https://opentdb.com/api.php';

  Future<List<dynamic>> fetchQuestions(int amount, int categoryId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?amount=$amount&category=$categoryId&type=multiple'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
/*
class PrintQuizzesWidget extends StatefulWidget {
  final int amount;
  final int categoryId;

  PrintQuizzesWidget({required this.amount, required this.categoryId});

  @override
  _PrintQuizzesWidgetState createState() => _PrintQuizzesWidgetState();
}

class _PrintQuizzesWidgetState extends State<PrintQuizzesWidget>
    with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> questions;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    questions =
        TriviaService().fetchQuestions(widget.amount, widget.categoryId);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia Quiz'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Questions & Answers'),
            Tab(text: 'Correct Answers'),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: questions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final questionsList = snapshot.data!;
            return TabBarView(
              controller: _tabController,
              children: [
                // Questions and Answers Tab
                ListView.builder(
                  itemCount: questionsList.length,
                  itemBuilder: (context, index) {
                    final question = questionsList[index];
                    final allAnswers = [
                      ...question['incorrect_answers'],
                      question['correct_answer']
                    ];
                    allAnswers
                        .shuffle(); // Shuffle to randomize answer positions

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}: ${question['question']}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ...allAnswers.asMap().entries.map((entry) {
                              int idx = entry.key;
                              String answer = entry.value;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                    '${String.fromCharCode(97 + idx)}) $answer'),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Correct Answers Tab
                ListView.builder(
                  itemCount: questionsList.length,
                  itemBuilder: (context, index) {
                    final question = questionsList[index];

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}: ${question['question']}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                                'Correct Answer: ${question['correct_answer']}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
*/

class PrintQuizzesWidget extends StatefulWidget {
  final int amount;
  final int categoryId;

  PrintQuizzesWidget({required this.amount, required this.categoryId});

  @override
  _PrintQuizzesWidgetState createState() => _PrintQuizzesWidgetState();
}

class _PrintQuizzesWidgetState extends State<PrintQuizzesWidget>
    with SingleTickerProviderStateMixin {
  Future<List<dynamic>>? questions;
  late TabController _tabController;
  StreamSubscription? internetConnectionStreamSubs;
  bool isConnected = true;
  bool isPrinterConnected = false;
  AppDatabase noteDatabase = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    // Initialize the Future to an empty or placeholder Future.
    questions = Future.value([]);

    internetConnectionStreamSubs =
        InternetConnection().onStatusChange.listen((event) {
      log('event: $event');
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnected = true;
            checkPrinterInDB();
            questions = TriviaService()
                .fetchQuestions(widget.amount, widget.categoryId);
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

    _tabController = TabController(length: 2, vsync: this);
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
    _tabController.dispose();
    internetConnectionStreamSubs?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    log('Connected Status: $isConnected');

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        centerTitle: true,
        title: Text(
          localization.triviaQuiz,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20.fontSize,
            color: AppColor.blackColor,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColor.blackColor,
          unselectedLabelColor: AppColor.greyColor,
          indicatorColor: AppColor.bluish,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14.fontSize,
            color: AppColor.blackColor,
          ),
          tabs: [
            Tab(text: localization.questionsAndAnswers),
            Tab(text: localization.correctAnswers),
          ],
        ),
      ),
      body: isConnected
          ? FutureBuilder<List<dynamic>>(
              future: questions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.bluish),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Text(
                        '${localization.error} ${snapshot.error}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.fontSize,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ),
                  );
                } else {
                  final questionsList = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Questions and Answers Tab
                            ListView.builder(
                              itemCount: questionsList.length,
                              itemBuilder: (context, index) {
                                final question = questionsList[index];
                                List<String> allAnswers = [
                                  ...question['incorrect_answers'],
                                  question['correct_answer']
                                ];
                                allAnswers
                                    .shuffle(); // Shuffle to randomize answer positions

                                return Card(
                                  color: AppColor.whiteColor,
                                  margin: EdgeInsets.all(8.0),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${localization.question} ${index + 1}: ${question['question']}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.fontSize,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        ...allAnswers
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int idx = entry.key;
                                          String answer = entry.value;
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.h),
                                            child: Text(
                                              '${String.fromCharCode(97 + idx)}) $answer',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.fontSize,
                                                color: AppColor.blackColor,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Correct Answers Tab
                            ListView.builder(
                              itemCount: questionsList.length,
                              itemBuilder: (context, index) {
                                final question = questionsList[index];

                                return Card(
                                  margin: EdgeInsets.all(8.0),
                                  elevation: 2,
                                  color: AppColor.whiteColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${localization.question} ${index + 1}: ${question['question']}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.fontSize,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '${localization.correctAnswer} ${question['correct_answer']}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.fontSize,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Centered Print Button
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (isPrinterConnected) {
                              final snapshot = await questions;
                              if (snapshot != null) {
                                _printQuiz(snapshot);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No Data'),
                                  ),
                                );
                              }
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.bluish,
                          ),
                          child: Text(
                            localization.printQuiz,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.fontSize,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
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
                        type: AppSettingsType.wifi,
                      ),
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
    );
  }

  Future<void> _printQuiz(List<dynamic> questionsList) async {
    final pdf = pw.Document();
    const double questionHeight = 200; // Adjust this value based on your layout
    const double spacing = 20; // Space between questions
    const double margin = 20; // Margins on the page
    double pageHeight = PdfPageFormat.a4.height;
    double usableHeight =
        pageHeight - (2 * margin); // Usable height for questions
    const int minQuestionsPerPage = 2; // Minimum questions per page
    int maxQuestionsPerPage =
        ((usableHeight) / (questionHeight + spacing)).floor();
    maxQuestionsPerPage = maxQuestionsPerPage < minQuestionsPerPage
        ? minQuestionsPerPage
        : maxQuestionsPerPage;

    int totalQuestions = questionsList.length;
    int globalQuestionNumber = 1; // Start numbering from 1

    for (int currentQuestionIndex = 0;
        currentQuestionIndex < totalQuestions;
        currentQuestionIndex += maxQuestionsPerPage) {
      // Get the specific range of questions for the current page
      final pageQuestions = questionsList.sublist(
        currentQuestionIndex,
        (currentQuestionIndex + maxQuestionsPerPage) > totalQuestions
            ? totalQuestions
            : currentQuestionIndex + maxQuestionsPerPage,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: pw.EdgeInsets.all(margin),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  ...pageQuestions.map((question) {
                    List<String> allAnswers = [
                      ...question['incorrect_answers'],
                      question['correct_answer']
                    ];
                    allAnswers
                        .shuffle(); // Shuffle to randomize answer positions

                    final questionWidget = pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Question ${globalQuestionNumber++}: ${question['question']}',
                          // Increment here
                          style: pw.TextStyle(fontSize: 24),
                        ),
                        pw.SizedBox(height: 10),
                        if (_tabController.index == 1) ...[
                          pw.Text(
                            'Correct Answer: ${question['correct_answer']}',
                            style: pw.TextStyle(
                                fontSize: 18, fontWeight: pw.FontWeight.bold),
                          ),
                        ] else ...[
                          pw.Text('Options:',
                              style: pw.TextStyle(fontSize: 18)),
                          ...allAnswers.asMap().entries.map((entry) {
                            int idx = entry.key;
                            String answer = entry.value;
                            return pw.Text(
                                '${String.fromCharCode(97 + idx)}) $answer');
                          }).toList(),
                        ],
                      ],
                    );

                    return pw.Padding(
                      padding: pw.EdgeInsets.only(bottom: spacing),
                      child: questionWidget,
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      );
    }

    // Print the PDF document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
