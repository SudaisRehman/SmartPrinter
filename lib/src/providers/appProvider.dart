import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:math';

class AppProvider with ChangeNotifier {
  AppProvider() {}
  int _tapCount = 0;

  int get tapCount => _tapCount;

  void incrementTapCount() {
    _tapCount++;
    notifyListeners();
  }
}
