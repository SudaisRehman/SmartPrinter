import 'package:flutter/material.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';

import 'colors.dart';

class MyRadioButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final String imagePath;
  final bool isFilled;

  const MyRadioButton({
    super.key,
    required this.text,
    required this.imagePath,
    required this.isFilled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 343.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(
            color: isFilled ? AppColor.bluish : AppColor.whiteColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 32.w,
              height: 32.w,
            ),
            SizedBox(width: 20.w),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColor.blackColor,
                fontSize: 14.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Image.asset(
              'icons/new/checked_radio.webp',
              color: isFilled ? AppColor.mainThemeColor : AppColor.greyColor,
              width: 20.w,
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
