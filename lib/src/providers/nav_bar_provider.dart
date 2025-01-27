import 'package:flutter/material.dart';
import '../widgets/print_dashboard.dart';
import '../widgets/scan_document.dart';
import '../widgets/settings_widget.dart';

class NavBarProvider extends ChangeNotifier {
  int _navBarIndex = 0;

  final List _navBarBody = [
    const PrintDashboardWidget(),
    const ScanDocumentWidget(),
    SettingsWidget(),
  ];

  int get navBarIndex => _navBarIndex;

  List get navBarBody => _navBarBody;

  void setNavBarIndex(int index) {
    _navBarIndex = index;
    notifyListeners();
  }
}
