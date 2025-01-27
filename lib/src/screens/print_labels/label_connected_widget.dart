import 'package:flutter/material.dart';

import '../print_calendar/image_preview_screen.dart';
import '../print_calendar/images_list_model.dart';


class LabelConnectedWidget extends StatefulWidget {
  const LabelConnectedWidget({super.key});

  @override
  State<LabelConnectedWidget> createState() => _LabelConnectedWidgetState();
}

class _LabelConnectedWidgetState extends State<LabelConnectedWidget> {
  String selectedLabel = 'Beach and Summer';
  int labelIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 15),
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
            value: selectedLabel,
            items: [
              'Beach and Summer',
              'Coffee',
              'Book Lover',
              'Baby',
              'Happy Birth Day',
              'Love',
              'Happy Easter',
              'Bear',
              'Graduation',
              'Butterfly',
              'Frames',
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
                selectedLabel = newValue!;
                labelIndex = -1;
              });
            },
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: GridView.builder(
              itemCount: () {
                switch (selectedLabel) {
                  case 'Beach and Summer':
                    return beachAndSummerImages.length;
                  case 'Coffee':
                    return coffeeImages.length;
                  case 'Book Lover':
                    return bookLoverImages.length;
                  case 'Baby':
                    return babyImages.length;
                  case 'Happy Birth Day':
                    return happyBirthDayImages.length;
                  case 'Love':
                    return loveImages.length;
                  case 'Happy Easter':
                    return happyEasterImages.length;
                  case 'Bear':
                    return bearImages.length;
                  case 'Graduation':
                    return graduationImages.length;
                  case 'Butterfly':
                    return butterflyImages.length;
                  case 'Frames':
                    return framesImages.length;
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
                  switch (selectedLabel) {
                    case 'Beach and Summer':
                      return beachAndSummerImages[index];
                    case 'Coffee':
                      return coffeeImages[index];
                    case 'Book Lover':
                      return bookLoverImages[index];
                    case 'Baby':
                      return babyImages[index];
                    case 'Happy Birth Day':
                      return happyBirthDayImages[index];
                    case 'Love':
                      return loveImages[index];
                    case 'Happy Easter':
                      return happyEasterImages[index];
                    case 'Bear':
                      return bearImages[index];
                    case 'Graduation':
                      return graduationImages[index];
                    case 'Butterfly':
                      return butterflyImages[index];
                    case 'Frames':
                      return framesImages[index];
                    default:
                      return '';
                  }
                }();
                final selected = labelIndex == index;

                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (labelIndex == index) {
                            labelIndex = -1;
                          } else {
                            labelIndex = index;
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
            if (labelIndex != -1) {
              final selectedImagePath = () {
                switch (selectedLabel) {
                  case 'Beach and Summer':
                    return beachAndSummerImages[labelIndex];
                  case 'Coffee':
                    return coffeeImages[labelIndex];
                  case 'Book Lover':
                    return bookLoverImages[labelIndex];
                  case 'Baby':
                    return babyImages[labelIndex];
                  case 'Happy Birth Day':
                    return happyBirthDayImages[labelIndex];
                  case 'Love':
                    return loveImages[labelIndex];
                  case 'Happy Easter':
                    return happyEasterImages[labelIndex];
                  case 'Bear':
                    return bearImages[labelIndex];
                  case 'Graduation':
                    return graduationImages[labelIndex];
                  case 'Butterfly':
                    return butterflyImages[labelIndex];
                  case 'Frames':
                    return framesImages[labelIndex];

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
