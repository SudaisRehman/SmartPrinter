import 'dart:developer';

import 'package:flutter/material.dart';

import 'image_preview_screen.dart';
import 'images_list_model.dart';


class MonthlyListWidget extends StatefulWidget {
  const MonthlyListWidget({super.key});

  @override
  State<MonthlyListWidget> createState() => _MonthlyListWidgetState();
}

class _MonthlyListWidgetState extends State<MonthlyListWidget> {
  String selectedMonth = 'January';
  int monthlyIndex = 0;

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
            value: selectedMonth,
            items: [
              'January',
              'February',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December',
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
                selectedMonth = newValue!;
                monthlyIndex = -1;
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
        Container(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: GridView.builder(
              itemCount: () {
                switch (selectedMonth) {
                  case 'January':
                    return januaryImages.length;
                  case 'February':
                    return februaryImages.length;
                  case 'March':
                    return marchImages.length;
                  case 'April':
                    return aprilImages.length;
                  case 'May':
                    return mayImages.length;
                  case 'June':
                    return juneImages.length;
                  case 'July':
                    return julyImages.length;
                  case 'August':
                    return augustImages.length;
                  case 'September':
                    return septemberImages.length;
                  case 'October':
                    return octoberImages.length;
                  case 'November':
                    return novemberImages.length;
                  case 'December':
                    return decemberImages.length;
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
                  switch (selectedMonth) {
                    case 'January':
                      return januaryImages[index];
                    case 'February':
                      return februaryImages[index];
                    case 'March':
                      return marchImages[index];
                    case 'April':
                      return aprilImages[index];
                    case 'May':
                      return mayImages[index];
                    case 'June':
                      return juneImages[index];
                    case 'July':
                      return julyImages[index];
                    case 'August':
                      return augustImages[index];
                    case 'September':
                      return septemberImages[index];
                    case 'October':
                      return octoberImages[index];
                    case 'November':
                      return novemberImages[index];
                    case 'December':
                      return decemberImages[index];
                    default:
                      return '';
                  }
                }();
                final selected = monthlyIndex == index;

                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (monthlyIndex == index) {
                            monthlyIndex = -1;
                          } else {
                            monthlyIndex = index;
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
            if (monthlyIndex != -1) {
              final selectedImagePath = () {
                switch (selectedMonth) {
                  case 'January':
                    return januaryImages[monthlyIndex];
                  case 'February':
                    return februaryImages[monthlyIndex];
                  case 'March':
                    return marchImages[monthlyIndex];
                  case 'April':
                    return aprilImages[monthlyIndex];
                  case 'May':
                    return mayImages[monthlyIndex];
                  case 'June':
                    return juneImages[monthlyIndex];
                  case 'July':
                    return julyImages[monthlyIndex];
                  case 'August':
                    return augustImages[monthlyIndex];
                  case 'September':
                    return septemberImages[monthlyIndex];
                  case 'October':
                    return octoberImages[monthlyIndex];
                  case 'November':
                    return novemberImages[monthlyIndex];
                  case 'December':
                    return decemberImages[monthlyIndex];
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
