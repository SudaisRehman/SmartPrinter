import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../not_connected_widget.dart';
import 'connected_widget.dart';


class PrintCalendarScreen extends StatefulWidget {
  const PrintCalendarScreen({super.key});

  @override
  State<PrintCalendarScreen> createState() => _PrintCalendarScreenState();
}

class _PrintCalendarScreenState extends State<PrintCalendarScreen> {
  bool isConnected = true;
  StreamSubscription? internetConnectionStreamSubs;
  // String selectedtype = 'Month';
  // String selectedMonth = 'January';
  // String selectedYear = '2024';
  // int monthlyIndex = 0;
  // int yearlyIndex = 0;

  @override
  void initState() {
    internetConnectionStreamSubs = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnected = true;
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    internetConnectionStreamSubs?.cancel();
  }

  // Text Button
  // Widget myTextButton({
  //   required Function()? onTap,
  //   required String text,
  //   required bool isSelected,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //         decorationStyle: TextDecorationStyle.solid,
  //         decorationColor: Colors.blue,
  //         decoration: isSelected ? TextDecoration.underline : null,
  //         fontFamily: 'Poppins',
  //         fontWeight: FontWeight.w500,
  //         fontSize: 14,
  //         color: isSelected ? Colors.blue : Colors.black,
  //       ),
  //     ),
  //   );
  // }

  // List<String> monthlyImages = [
  //   'icons/new/gmail.png',
  //   'icons/new/icloud.png',
  //   'icons/new/other.png',
  //   'icons/new/outlook.png',
  // ];
  // String monthName = 'January';
  // List<String> januaryImages = [
  //   'icons/new/gmail.png',
  //   'icons/print_quizzes.png',
  // ];
  // List<String> februaryImages = [
  //   'icons/new/icloud.png',
  //   'icons/print_quizzes.png',
  // ];
  // List<String> marchImages = [
  //   'icons/new/other.png',
  //   'icons/print_quizzes.png',
  // ];
  // List<String> aprilImages = [
  //   'icons/new/outlook.png',
  //   'icons/print_quizzes.png',
  // ];

  // List<String> yearlyImages = [
  //   'icons/print_labels.png',
  //   'icons/print_one_drive.png',
  //   'icons/print_document.png',
  //   'icons/print_quizzes.png',
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Calendar',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: isConnected ? ConnectedWidget() : NotConnectedWidget(),
      ),
    );
  }

  // Connected Widget
  // Widget connectedWidget() {
  //   return Center(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         // Buttons Row
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             myTextButton(
  //               onTap: () {
  //                 setState(() {
  //                   selectedtype = 'Month';
  //                 });
  //               },
  //               text: 'Month',
  //               isSelected: selectedtype == 'Month',
  //             ),
  //             SizedBox(width: 80),
  //             myTextButton(
  //               onTap: () {
  //                 setState(() {
  //                   selectedtype = 'Year';
  //                 });
  //               },
  //               text: 'Year',
  //               isSelected: selectedtype == 'Year',
  //             ),
  //           ],
  //         ),

  //         SizedBox(height: 15),

  //         // Main Body
  //         ...(selectedtype == 'Month' ? monthlyListWidget() : yearlyListWidget()),
  //       ],
  //     ),
  //   );
  // }

  // Yearly List Of Widgets
  // List<Widget> yearlyListWidget() {
  //   return [
  //     Container(
  //       width: 320,
  //       padding: EdgeInsets.symmetric(horizontal: 20),
  //       decoration: BoxDecoration(
  //         color: Color(0xff17BDD3),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: DropdownButton<String>(
  //         underline: SizedBox(),
  //         iconSize: 30,
  //         isExpanded: true,
  //         iconEnabledColor: Colors.white,
  //         menuWidth: 300,
  //         borderRadius: BorderRadius.circular(12),
  //         dropdownColor: Color(0xff17BDD3),
  //         value: selectedYear,
  //         items: [
  //           '2024',
  //           '2025',
  //         ].map((value) {
  //           return DropdownMenuItem<String>(
  //             value: value,
  //             child: Text(
  //               value,
  //               style: TextStyle(
  //                 fontFamily: 'Poppins',
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 14,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (newValue) {
  //           setState(() {
  //             selectedYear = newValue!;
  //           });
  //         },
  //       ),
  //     ),
  //     SizedBox(height: 10),
  //     Text(
  //       'Chosse Layout',
  //       style: TextStyle(
  //         fontFamily: 'Poppins',
  //         fontWeight: FontWeight.w500,
  //         fontSize: 11,
  //       ),
  //     ),
  //     SizedBox(height: 10),
  //     Expanded(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
  //         child: GridView.builder(
  //           itemCount: yearlyImages.length,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             mainAxisSpacing: 20,
  //             childAspectRatio: 1.2,
  //           ),
  //           itemBuilder: (context, index) {
  //             final imagePath = yearlyImages[index];
  //             final selected = yearlyIndex == index;

  //             return Stack(
  //               alignment: Alignment.topRight,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       yearlyIndex = index;
  //                     });
  //                   },
  //                   child: Container(
  //                     height: 150,
  //                     width: 150,
  //                     padding: EdgeInsets.all(15),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(color: Color(0xff17BDD3)),
  //                     ),
  //                     child: Image.asset(imagePath),
  //                   ),
  //                 ),
  //                 selected
  //                     ? Icon(
  //                         Icons.check,
  //                         color: Color(0xff17BDD3),
  //                         size: 30,
  //                       )
  //                     : SizedBox(),
  //               ],
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //     InkWell(
  //       onTap: () {},
  //       child: Container(
  //         height: 40,
  //         width: 200,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: Color(0xff17BDD3),
  //         ),
  //         child: Center(
  //           child: Text(
  //             'Next',
  //             style: TextStyle(
  //               fontFamily: 'Poppins',
  //               fontWeight: FontWeight.w600,
  //               fontSize: 16,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //     SizedBox(height: 15),
  //   ];
  // }

  // Monthly List Of Widgets
  // List<Widget> monthlyListWidget() {
  //   return [
  //     Container(
  //       width: 320,
  //       padding: EdgeInsets.symmetric(horizontal: 20),
  //       decoration: BoxDecoration(
  //         color: Color(0xff17BDD3),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: DropdownButton<String>(
  //         underline: SizedBox(),
  //         iconSize: 30,
  //         isExpanded: true,
  //         iconEnabledColor: Colors.white,
  //         menuWidth: 300,
  //         borderRadius: BorderRadius.circular(12),
  //         dropdownColor: Color(0xff17BDD3),
  //         value: selectedMonth,
  //         items: [
  //           'January',
  //           'February',
  //           'March',
  //           'April',
  //           'May',
  //           'June',
  //           'July',
  //           'August',
  //           'September',
  //           'October',
  //           'November',
  //           'December',
  //         ].map((value) {
  //           return DropdownMenuItem<String>(
  //             value: value,
  //             child: Text(
  //               value,
  //               style: TextStyle(
  //                 fontFamily: 'Poppins',
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 14,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (newValue) {
  //           setState(() {
  //             selectedMonth = newValue!;
  //             monthlyIndex = -1;
  //           });
  //         },
  //       ),
  //     ),
  //     SizedBox(height: 10),
  //     Text(
  //       'Chosse Layout',
  //       style: TextStyle(
  //         fontFamily: 'Poppins',
  //         fontWeight: FontWeight.w500,
  //         fontSize: 11,
  //       ),
  //     ),
  //     SizedBox(height: 10),
  //     Expanded(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
  //         child: GridView.builder(
  //           itemCount: () {
  //             switch (selectedMonth) {
  //               case 'January':
  //                 return januaryImages.length;
  //               case 'February':
  //                 return februaryImages.length;
  //               default:
  //                 return null;
  //             }
  //           }(),
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             mainAxisSpacing: 20,
  //             childAspectRatio: 1.2,
  //           ),
  //           itemBuilder: (context, index) {
  //             // final imagePath = monthlyImages[index];
  //             final imagePath = () {
  //               switch (selectedMonth) {
  //                 case 'January':
  //                   return januaryImages[index];
  //                 case 'February':
  //                   return februaryImages[index];
  //                 default:
  //                   return '';
  //               }
  //             }();
  //             final selected = monthlyIndex == index;

  //             return Stack(
  //               alignment: Alignment.topRight,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       monthlyIndex = index;
  //                     });
  //                   },
  //                   child: Container(
  //                     height: 150,
  //                     width: 150,
  //                     padding: EdgeInsets.all(15),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(color: Color(0xff17BDD3)),
  //                     ),
  //                     child: Image.asset(imagePath),
  //                   ),
  //                 ),
  //                 selected
  //                     ? Icon(
  //                         Icons.check,
  //                         color: Color(0xff17BDD3),
  //                         size: 30,
  //                       )
  //                     : SizedBox(),
  //               ],
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //     InkWell(
  //       onTap: () {},
  //       child: Container(
  //         height: 40,
  //         width: 200,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: Color(0xff17BDD3),
  //         ),
  //         child: Center(
  //           child: Text(
  //             'Next',
  //             style: TextStyle(
  //               fontFamily: 'Poppins',
  //               fontWeight: FontWeight.w600,
  //               fontSize: 16,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //     SizedBox(height: 15),
  //   ];
  // }

  // No Internet Widget
  // Widget notConnectedWidget() {
  //   return Center(
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 40),
  //       padding: EdgeInsets.symmetric(vertical: 10),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Image.asset(
  //             'icons/new/wifi_icon.png',
  //             width: 45,
  //           ),
  //           SizedBox(height: 10),
  //           Text(
  //             'No WiFi or Data Network',
  //             style: TextStyle(
  //               fontFamily: 'Poppins',
  //               fontWeight: FontWeight.w600,
  //               fontSize: 14,
  //             ),
  //           ),
  //           SizedBox(height: 1),
  //           Text(
  //             'This device is not connected to WiFi or Data Network right now. Make sure it’s connected so that you can use the smart printer',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontFamily: 'Poppins',
  //               fontWeight: FontWeight.w500,
  //               fontSize: 12,
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           InkWell(
  //             onTap: () => AppSettings.openAppSettings(type: AppSettingsType.wifi),
  //             child: Container(
  //               height: 35,
  //               width: 250,
  //               margin: EdgeInsets.symmetric(horizontal: 10),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 color: Color(0xff17BDD3),
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   'Connect to WiFi or Data Network',
  //                   style: TextStyle(
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 13,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
