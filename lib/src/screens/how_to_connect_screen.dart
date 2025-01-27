import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import '../utils/colors.dart';
import '../widgets/print_help_center_detail.dart';

class HowToConnectScreen extends StatelessWidget {
  const HowToConnectScreen({super.key});

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
                  localization.howToConnect,
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
      body: Column(
        children: [
          buildPrinterOption(context, localization.hpPrinters),
          buildPrinterOption(context, localization.brother),
          buildPrinterOption(context, localization.epson),
          buildPrinterOption(context, localization.canon),
          buildPrinterOption(context, localization.fujiXerox),
          buildPrinterOption(context, localization.lexmark),
        ],
      ),
    );
  }

  Widget buildPrinterOption(BuildContext context, String printerName) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        color: AppColor.menuColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrinterDetails(printerName: printerName),
            ),
          );
        },
        title: Text(
          printerName,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.fontSize,
            color: AppColor.whiteColor,
          ),
        ),
        trailing: SvgPicture.asset(
          "icons/next_arrow_icon.svg",
          semanticsLabel: 'A red up arrow',
        ),
      ),
    );
  }

}
