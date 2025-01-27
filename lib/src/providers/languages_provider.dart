import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagesProvider extends ChangeNotifier {
  Locale _appLocale = const Locale('en');
  String searchQuery = '';
  Map<String, Map<String, String>> languagesMap = {};

  Locale get appLocale => _appLocale;

  LanguagesProvider(Locale locale) {
    _appLocale = locale;
    _initializeLanguagesMap();
  }

  void _initializeLanguagesMap() {
    languagesMap = {
      'en': {'name': 'English', 'flag': 'icons/new/english.webp'},
      'ja': {'name': 'Japanese', 'flag': 'icons/new/japanese.webp'},
      'hi': {'name': 'Hindi', 'flag': 'icons/new/hindi.webp'},
      'es': {'name': 'Spanish', 'flag': 'icons/new/spanish.webp'},
      'fr': {'name': 'French', 'flag': 'icons/new/french.webp'},
      'ar': {'name': 'Arabic', 'flag': 'icons/new/arabic.webp'},
      'bn': {'name': 'Bengali', 'flag': 'icons/new/bengali.webp'},
      'ru': {'name': 'Russian', 'flag': 'icons/new/russian.webp'},
      'it': {'name': 'Italian', 'flag': 'icons/new/italian.webp'},
    };
  }

  void changeLanguage(Locale locale) async {
    _appLocale = locale;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  Future<void> loadStoredLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _appLocale = Locale(languageCode);
      notifyListeners();
    }
  }
}
