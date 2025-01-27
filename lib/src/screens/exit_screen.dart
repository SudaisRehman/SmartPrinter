import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printer_app/src/utils/colors.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExitScreen extends StatelessWidget {
  const ExitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
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
                child: Text(
                  localization.exit,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20.fontSize,
                  ),
                ),
              ),
              SizedBox(width: 40.w),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5.h),
              Image.asset(
                'icons/new/big_star.webp',
                width: 50.w,
                height: 50.h,
              ),
              SizedBox(height: 15.h),
              Text(
                localization.lovedOutSmartPrinter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 15.fontSize,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                localization.showYourSupportByRating,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 13.fontSize,
                ),
              ),
              SizedBox(height: 12.h),
              Image.asset(
                'icons/new/group_stars.webp',
                width: 230.w,
                height: 50.h,
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => SystemNavigator.pop(),
                    child: Container(
                      width: 100.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: AppColor.mainThemeColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          localization.exit,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16.fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 100.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.mainThemeColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          localization.submit,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: AppColor.mainThemeColor,
                            fontSize: 16.fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
