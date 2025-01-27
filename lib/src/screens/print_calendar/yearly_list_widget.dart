import 'package:flutter/material.dart';

import 'image_preview_screen.dart';
import 'images_list_model.dart';


class YearlyListWidget extends StatefulWidget {
  const YearlyListWidget({super.key});

  @override
  State<YearlyListWidget> createState() => _YearlyListWidgetState();
}

class _YearlyListWidgetState extends State<YearlyListWidget> {
  String selectedYear = '2024';
  int yearlyIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 320,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xff17BDD3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            underline: SizedBox(),
            iconSize: 30,
            isExpanded: true,
            iconEnabledColor: Colors.white,
            menuWidth: 300,
            borderRadius: BorderRadius.circular(12),
            dropdownColor: Color(0xff17BDD3),
            value: selectedYear,
            items: [
              '2024',
              '2025',
            ].map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedYear = newValue!;
                yearlyIndex = -1;
              });
            },
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Chosse Layout',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: GridView.builder(
              itemCount: () {
                switch (selectedYear) {
                  case '2024':
                    return year2024.length;
                  case '2025':
                    return year2025.length;
                  default:
                    return null;
                }
              }(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final imagePath = () {
                  switch (selectedYear) {
                    case '2024':
                      return year2024[index];
                    case '2025':
                      return year2025[index];
                    default:
                      return '';
                  }
                }();
                final selected = yearlyIndex == index;

                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (yearlyIndex == index) {
                            yearlyIndex = -1;
                          } else {
                            yearlyIndex = index;
                          }
                        });
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color(0xff17BDD3)),
                        ),
                        child: Image.asset(imagePath),
                      ),
                    ),
                    selected
                        ? Icon(
                            Icons.check,
                            color: Color(0xff17BDD3),
                            size: 30,
                          )
                        : SizedBox(),
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            // Ensure that a valid index is selected
            if (yearlyIndex != -1) {
              final selectedImagePath = () {
                switch (selectedYear) {
                  case '2024':
                    return year2024[yearlyIndex];
                  case '2025':
                    return year2025[yearlyIndex];
                  default:
                    return '';
                }
              }();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImagePreviewScreen(imagePath: selectedImagePath),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please select an image first')),
              );
            }
          },
          child: Container(
            height: 40,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff17BDD3),
            ),
            child: Center(
              child: Text(
                'Next',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
