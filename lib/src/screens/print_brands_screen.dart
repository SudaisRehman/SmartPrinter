import 'package:flutter/material.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import '../utils/colors.dart';
import '../utils/my_toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintBrandsScreen extends StatefulWidget {
  const PrintBrandsScreen({super.key});

  @override
  State<PrintBrandsScreen> createState() => _PrintBrandsScreenState();
}

class _PrintBrandsScreenState extends State<PrintBrandsScreen> {
  late List<String> printersName = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localization = AppLocalizations.of(context)!;

    printersName = [
      localization.dell,
      localization.samsung,
      localization.toshiba,
      localization.brother,
      localization.epson,
      localization.canon,
      localization.kyocera,
      localization.lexmark,
      localization.ricoh,
      localization.hp,
    ];
  }

  final List<Color> textColors = [
    AppColor.bluish,
    AppColor.darkBlue,
    AppColor.darkRed,
    AppColor.darkBlackBlue,
    AppColor.darkBlue,
    AppColor.darkBlackRed,
    AppColor.darkRed,
    AppColor.lightGreen,
    AppColor.blackColor,
    AppColor.bluish,
  ];

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
                  localization.printBrands,
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
            SizedBox(width: 65.w),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 15.h,
          ),
          padding: EdgeInsets.only(bottom: 45.h,top: 10.h),
          itemCount: printersName.length,
          itemBuilder: (context, index) {
            final names = printersName[index];
            return InkWell(
              onTap: () {
                showToast(
                  context: context,
                  message: '$names ${localization.printerSupported}',
                );
              },
              child: Container(
                height: 80.h,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColor.lightGray3.withOpacity(.6),
                  ),
                ),
                child: Center(
                  child: Text(
                    names,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.fontSize,
                      color: textColors[index % textColors.length],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
