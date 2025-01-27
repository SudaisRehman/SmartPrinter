import 'package:flutter/material.dart';
import 'package:printer_app/src/alphabets_list.dart';
import 'package:printer_app/src/utils/colors.dart';
import 'package:printer_app/src/utils/sizer/sizer.dart';
import 'package:printer_app/src/utils/strings.dart';
import 'discover_printer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectUiWidget extends StatefulWidget {
  const ConnectUiWidget({super.key});

  @override
  State<ConnectUiWidget> createState() => _ConnectUiWidgetState();
}

class _ConnectUiWidgetState extends State<ConnectUiWidget> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return PopScope(
      canPop: true,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            backgroundColor: AppColor.transparentColor,
            title: Text(
              localization.selectPrinterBrand,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AppColor.blackColor,
                fontSize: 20.fontSize,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Auto Search Printer
              Container(
                margin: EdgeInsets.only(top: 15.h),
                child: InkWell(
                  onTap: () {
                    _openDiscoverPrinter(context);
                  },
                  child: Container(
                    width: 200.w,
                    padding: EdgeInsets.only(
                      left: 10.w,
                      right: 10.w,
                      top: 8.h,
                      bottom: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17BDD3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      child: Text(
                        localization.autoSearchPrinter,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.fontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Or select your printer brand
              Container(
                padding: EdgeInsets.only(
                  top: 10.h,
                  bottom: 5.h,
                ),
                child: Text(
                  localization.orSelectYourPrinterBrand,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 12.fontSize,
                  ),
                ),
              ),
              Expanded(
                child: AlphabetsList(
                  selectedIndex: -1,
                  list: printerList,
                  onPrinterSelection: (index) {
                    _openDiscoverPrinter(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDiscoverPrinter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscoverUi(
          onAction: () {},
          onClose: () {},
        ),
      ),
    );
  }
}
