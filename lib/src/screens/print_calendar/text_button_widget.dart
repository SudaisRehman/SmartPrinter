import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool isSelected;
  const TextButtonWidget(
      {super.key, this.onTap, required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          decorationStyle: TextDecorationStyle.solid,
          decorationColor: Colors.blue,
          decoration: isSelected ? TextDecoration.underline : null,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: isSelected ? Colors.blue : Colors.black,
        ),
      ),
    );
  }
}
