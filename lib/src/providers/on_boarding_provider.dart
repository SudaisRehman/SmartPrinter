import 'package:flutter/material.dart';

class OnBoardingProvider extends ChangeNotifier {
  bool _onLastPage = false;
  PageController pageController = PageController();

  bool get onLastPage => _onLastPage;

  void setPageIndex(int index) {
    _onLastPage = index == 4;

    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    // _controller.dispose();
    super.dispose();
  }
}
