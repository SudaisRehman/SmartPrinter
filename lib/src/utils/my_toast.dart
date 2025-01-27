import 'package:flutter/material.dart';
import 'package:printer_app/src/utils/colors.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';

void showToast({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: AppColor.whiteColor,
          fontSize: 13.fontSize,
        ),
      ),
    ),
  );
}
