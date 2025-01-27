import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:printer_app/src/utils/colors.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'print_quizzes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

class QuizCreationWidget extends StatefulWidget {
  const QuizCreationWidget({super.key});

  @override
  _QuizCreationWidgetState createState() => _QuizCreationWidgetState();
}

class _QuizCreationWidgetState extends State<QuizCreationWidget> {
  int questionCount = 10; // Default question count
  int selectedTopicIndex = -1; // Default: No topic selected
  late List<String> topics = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localization = AppLocalizations.of(context)!;

    topics = [
      localization.generalKnowledge,
      localization.science,
      localization.history,
      localization.geography,
      localization.technology,
      localization.literature,
      localization.foodAndDrinks,
      localization.tvShows,
      localization.movies,
      localization.music,
      localization.sports,
      localization.popCulture,
      localization.travel,
      localization.mathematics,
      localization.animals,
    ];
  }

  void _createQuiz({required AppLocalizations localization}) {
    if (selectedTopicIndex != -1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrintQuizzesWidget(
            amount: questionCount,
            categoryId:
                selectedTopicIndex + 9, // Adjust category id accordingly
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localization.pleaseSelectATopic,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 13.fontSize,
              color: AppColor.whiteColor,
            ),
          ),
        ),
      );
    }
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
          localization.createQuiz,
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
            // Chips for topics
            Wrap(
              spacing: 8.0,
              children: List<Widget>.generate(topics.length, (index) {
                return ChoiceChip(
                  backgroundColor: AppColor.whiteColor,
                  selectedColor: AppColor.bluish,
                  label: Text(
                    topics[index],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.fontSize,
                      color:  AppColor.blackColor,
                    ),
                  ),
                  selected: selectedTopicIndex == index,
                  onSelected: (selected) {
                    setState(() {
                      selectedTopicIndex = selected ? index : -1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 16.0),
            // Question Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (questionCount > 1) {
                      setState(() {
                        questionCount--;
                      });
                    }
                  },
                ),
                Text('${localization.questions} $questionCount'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      questionCount++;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            // Create Quiz Button
            ElevatedButton(
              onPressed: () => _createQuiz(localization: localization),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.bluish,
                minimumSize: Size(double.infinity, 50), // Full width
              ),
              child: Text(
                localization.createQuiz,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.fontSize,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
