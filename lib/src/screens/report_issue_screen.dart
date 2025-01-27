import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import '../utils/colors.dart';

class ReportIssueScreen extends StatelessWidget {
  const ReportIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24.iconSize,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 40),
                child: Text(
                  localization.reportIssue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20.fontSize,
                  ),
                ),
              ),
            ),
            SizedBox(width: 75.w),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.troubleWithPrinting,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 16.fontSize,
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.greyColor.withOpacity(.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                maxLines: 12,
                cursorColor: AppColor.blackColor,
                cursorWidth: 1.7,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14.fontSize,
                ),
                decoration: InputDecoration(
                  hintText: localization.reportAnyIssueYouEncounter,
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14.fontSize,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff17BDD3),
                  ),
                  child: Center(
                    child: Text(
                   localization.submit,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.fontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
