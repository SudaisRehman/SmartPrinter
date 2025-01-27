import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/strings.dart';

class SearchingPrinter extends StatelessWidget {
  const SearchingPrinter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Lottie.asset('icons/searching_icon.json'),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Text(
              Strings.discoveringPrinter,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
