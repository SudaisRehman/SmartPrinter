// import 'package:flutter/material.dart';
// import 'package:googleapis/composer/v1.dart';
// import 'package:printer_app/src/screens/exit_screen.dart';
// import 'package:printer_app/src/utils/colors.dart';
// import '../database/app_database.dart';
// import '../database/printer_model.dart';
// import '../widgets/print_dashboard.dart';
// import '../widgets/scan_document.dart';
// import '../widgets/settings_widget.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class HomeWidget extends StatefulWidget {
//   const HomeWidget({super.key});
//
//   @override
//   State<HomeWidget> createState() => _HomeWidgetState();
// }
//
// class _HomeWidgetState extends State<HomeWidget> {
//   AppDatabase noteDatabase = AppDatabase.instance;
//
//   late Future<List<PrintModel>> connectedPrinterList;
//   int _selectedTab = 0;
//
//   void onItemTapped(int index) {
//     setState(() {
//       _selectedTab = index;
//     });
//     print("tapping BottomNavigationBar : $index");
//   }
//
//   Widget getPage(int index) {
//     switch (index) {
//       case 0:
//         return PrintDashboardWidget();
//       case 1:
//         return ScanDocumentWidget();
//       default:
//         return SettingsWidget();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final localization = AppLocalizations.of(context)!;
//
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ExitScreen(),
//           ),
//         );
//       },
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: AppColor.scaffoldBgColor,
//           body: getPage(_selectedTab),
//           bottomNavigationBar: Container(
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(30),
//                 topLeft: Radius.circular(30),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColor.lightGreyColor,
//                   spreadRadius: 0,
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(30.0),
//                 topRight: Radius.circular(30.0),
//               ),
//               child: BottomNavigationBar(
//                 backgroundColor: AppColor.whiteColor,
//                 selectedIconTheme:
//                     const IconThemeData(color: AppColor.menuColor),
//                 type: BottomNavigationBarType.fixed,
//                 selectedItemColor: AppColor.menuColor,
//                 unselectedItemColor: AppColor.lightGreyColor,
//                 items: <BottomNavigationBarItem>[
//                   BottomNavigationBarItem(
//                     icon: SizedBox(
//                       height: 25,
//                       width: 25,
//                       child: Image.asset(
//                         'icons/icon_print_outline.webp',
//                         color: _selectedTab == 0
//                             ? AppColor.menuColor
//                             : AppColor.lightGreyColor,
//                       ),
//                     ),
//                     label: localization.print,
//                   ),
//                   BottomNavigationBarItem(
//                     icon: SizedBox(
//                       height: 25,
//                       width: 25,
//                       child: Image.asset(
//                         'icons/icon_menu_scan.webp',
//                         color: _selectedTab == 1
//                             ? AppColor.menuColor
//                             : AppColor.lightGreyColor,
//                       ),
//                     ),
//                     label: localization.scan,
//                   ),
//                   BottomNavigationBarItem(
//                     icon: SizedBox(
//                       height: 25,
//                       width: 25,
//                       child: Image.asset(
//                         'icons/icon_menu_settings.webp',
//                         color: _selectedTab == 2
//                             ? AppColor.menuColor
//                             : AppColor.lightGreyColor,
//                       ),
//                     ),
//                     label: localization.setting,
//                   ),
//                 ],
//                 currentIndex: _selectedTab,
//                 onTap: onItemTapped,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// //

import 'package:flutter/material.dart';
import 'package:printer_app/src/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/nav_bar_provider.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final provider = Provider.of<NavBarProvider>(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<NavBarProvider>(
          builder: (context, navBarProvider, child) {
            return navBarProvider.navBarBody
                .elementAt(navBarProvider.navBarIndex);
          },
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.lightGreyColor,
                spreadRadius: 0,
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: AppColor.whiteColor,
              selectedIconTheme: const IconThemeData(color: AppColor.menuColor),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColor.menuColor,
              unselectedItemColor: AppColor.lightGreyColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(
                      'icons/icon_print_outline.webp',
                      color: provider.navBarIndex == 0
                          ? AppColor.menuColor
                          : AppColor.lightGreyColor,
                    ),
                  ),
                  label: localization.print,
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(
                      'icons/icon_menu_scan.webp',
                      color: provider.navBarIndex == 1
                          ? AppColor.menuColor
                          : AppColor.lightGreyColor,
                    ),
                  ),
                  label: localization.scan,
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(
                      'icons/icon_menu_settings.webp',
                      color: provider.navBarIndex == 2
                          ? AppColor.menuColor
                          : AppColor.lightGreyColor,
                    ),
                  ),
                  label: localization.setting,
                ),
              ],
              currentIndex: provider.navBarIndex,
              onTap: (value) {
                provider.setNavBarIndex(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
