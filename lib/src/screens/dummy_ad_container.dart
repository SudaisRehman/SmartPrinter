import 'package:flutter/material.dart';

class DummyAdContainer extends StatelessWidget {
  const DummyAdContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 25, left: 25, right: 25),
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xff17BDD3).withOpacity(.5),
      ),
      child: const Align(
        alignment: Alignment.center,
        child: Text(
          "AD",
          style: TextStyle(
            color: Colors.black,
            fontSize: 50,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
