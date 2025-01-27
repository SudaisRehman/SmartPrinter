// import 'package:flutter/material.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';

// class AdConfigProvider extends ChangeNotifier {
//   bool _bannerCollapsible = false;
//   bool _bannerDocument = false;
//   bool _bannerNotes = false;
//   bool _bannerPhoto = false;
//   bool _bannerScan = false;
//   bool _interstitialHome = false;
//   bool _nativeClipboard = false;
//   bool _nativeNotes = false;
//   bool _nativeOnboarding1_2 = false;
//   bool _nativeOnboarding4 = false;
//   bool _nativePoster = false;
//   bool _nativeSheet_2_4 = false;
//   bool _nativeSheet_3_5 = false;
//   bool _nativeSheet_6_8 = false;
//   bool _openApp = false;
//   bool _splashInterstitial = false;

//   String _bannerCollapsibleId = '';
//   String _bannerDocumentId = '';
//   String _bannerNotesId = '';
//   String _bannerPhotoId = '';
//   String _bannerScanId = '';
//   String _interstitialHomeId = '';
//   String _nativeClipboardId = '';
//   String _nativeNotesId = '';
//   String _nativeOnboarding1_2Id = '';
//   String _nativeOnboarding4Id = '';
//   String _nativePosterId = '';
//   String _nativeSheet_2_4Id = '';
//   String _nativeSheet_3_5Id = '';
//   String _nativeSheet_6_8Id = '';
//   String _openAppId = '';
//   String _splashInterstitialId = '';

//   bool get bannerCollapsible => _bannerCollapsible;
//   bool get bannerDocument => _bannerDocument;
//   bool get bannerNotes => _bannerNotes;
//   bool get bannerPhoto => _bannerPhoto;
//   bool get bannerScan => _bannerScan;
//   bool get interstitialHome => _interstitialHome;
//   bool get nativeClipboard => _nativeClipboard;
//   bool get nativeNotes => _nativeNotes;
//   bool get nativeOnboarding1_2 => _nativeOnboarding1_2;
//   bool get nativeOnboarding4 => _nativeOnboarding4;
//   bool get nativePoster => _nativePoster;
//   bool get nativeSheet_2_4 => _nativeSheet_2_4;
//   bool get nativeSheet_3_5 => _nativeSheet_3_5;
//   bool get nativeSheet_6_8 => _nativeSheet_6_8;
//   bool get openApp => _openApp;
//   bool get splashInterstitial => _splashInterstitial;

//   String get bannerCollapsibleId => _bannerCollapsibleId;
//   String get bannerDocumentId => _bannerDocumentId;
//   String get bannerNotesId => _bannerNotesId;
//   String get bannerPhotoId => _bannerPhotoId;
//   String get bannerScanId => _bannerScanId;
//   String get interstitialHomeId => _interstitialHomeId;
//   String get nativeClipboardId => _nativeClipboardId;
//   String get nativeNotesId => _nativeNotesId;
//   String get nativeOnboarding1_2Id => _nativeOnboarding1_2Id;
//   String get nativeOnboarding4Id => _nativeOnboarding4Id;
//   String get nativePosterId => _nativePosterId;
//   String get nativeSheet_2_4Id => _nativeSheet_2_4Id;
//   String get nativeSheet_3_5Id => _nativeSheet_3_5Id;
//   String get nativeSheet_6_8Id => _nativeSheet_6_8Id;
//   String get openAppId => _openAppId;
//   String get splashInterstitialId => _splashInterstitialId;

//   AdConfigProvider() {
//     _initializeRemoteConfig();
//   }

//   Future<void> _initializeRemoteConfig() async {
//     print('Initializing remote config');
//     final remoteConfig = FirebaseRemoteConfig.instance;

//     try {
//       await remoteConfig.setConfigSettings(RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 10),
//         minimumFetchInterval: Duration.zero,
//       ));

//       await remoteConfig.setDefaults(<String, dynamic>{
//         'banner_collapsible': false,
//         'banner_document': false,
//         'banner_notes': false,
//         'banner_photo': false,
//         'banner_scan': false,
//         'interstitial_home': false,
//         'native_clipboard': false,
//         'native_notes': false,
//         'native_onboarding1_2': false,
//         'native_onboarding4': false,
//         'native_poster': false,
//         'native_sheet_2_4': false,
//         'native_sheet_3_5': false,
//         'native_sheet_6_8': false,
//         'open_app': false,
//         'splash_interstitial': false,
//         'banner_collapsible_id': 'ca-app-pub-3940256099942544/6300978111',
//         'banner_document_id': 'ca-app-pub-3940256099942544/6300978111',
//         'banner_notes_id': 'ca-app-pub-3940256099942544/6300978111',
//         'banner_photo_id': 'ca-app-pub-3940256099942544/6300978111',
//         'banner_scan_id': 'ca-app-pub-3940256099942544/6300978111',
//         'interstitial_home_id': 'ca-app-pub-3940256099942544/1033173712',
//         'native_clipboard_id': 'ca-app-pub-3940256099942544/2247696110',
//         'native_notes_id': 'ca-app-pub-3940256099942544/2247696110',
//         'native_onboarding1_2_id': 'ca-app-pub-3940256099942544/2247696110',
//         'native_onboarding4_id': 'ca-app-pub-3940256099942544/2247696110',
//         'native_poster_id': 'ca-app-pub-3940256099942544/2247696110',
//         'native_sheet_2_4_id': 'ca-app-pub-3940256099942544/2247696110',
//         'native_sheet_3_5_id': 'ca-app-pub-3940256099942544/2247696110',
//         'native_sheet_6_8_id': 'ca-app-pub-3940256099942544/2247696110',
//         'open_app_id': 'ca-app-pub-3940256099942544/9257395921',
//         'splash_interstitial_id': 'ca-app-pub-3940256099942544/1033173712',
//       });

//       await remoteConfig.fetchAndActivate();
//       print('Remote config fetched and activated');

//       _bannerCollapsible = remoteConfig.getBool('banner_collapsible');
//       _bannerDocument = remoteConfig.getBool('banner_document');
//       _bannerNotes = remoteConfig.getBool('banner_notes');
//       _bannerPhoto = remoteConfig.getBool('banner_photo');
//       _bannerScan = remoteConfig.getBool('banner_scan');
//       _interstitialHome = remoteConfig.getBool('interstitial_home');
//       _nativeClipboard = remoteConfig.getBool('native_clipboard');
//       _nativeNotes = remoteConfig.getBool('native_notes');
//       _nativeOnboarding1_2 = remoteConfig.getBool('native_onboarding1_2');
//       _nativeOnboarding4 = remoteConfig.getBool('native_onboarding4');
//       _nativePoster = remoteConfig.getBool('native_poster');
//       _nativeSheet_2_4 = remoteConfig.getBool('native_sheet_2_4');
//       _nativeSheet_3_5 = remoteConfig.getBool('native_sheet_3_5');
//       _nativeSheet_6_8 = remoteConfig.getBool('native_sheet_6_8');
//       _openApp = remoteConfig.getBool('open_app');
//       _splashInterstitial = remoteConfig.getBool('splash_interstitial');

//       _bannerCollapsibleId = remoteConfig.getString('banner_collapsible_id');
//       _bannerDocumentId = remoteConfig.getString('banner_document_id');
//       _bannerNotesId = remoteConfig.getString('banner_notes_id');
//       _bannerPhotoId = remoteConfig.getString('banner_photo_id');
//       _bannerScanId = remoteConfig.getString('banner_scan_id');
//       _interstitialHomeId = remoteConfig.getString('interstitial_home_id');
//       _nativeClipboardId = remoteConfig.getString('native_clipboard_id');
//       _nativeNotesId = remoteConfig.getString('native_notes_id');
//       _nativeOnboarding1_2Id =
//           remoteConfig.getString('native_onboarding1_2_id');
//       _nativeOnboarding4Id = remoteConfig.getString('native_onboarding4_id');
//       _nativePosterId = remoteConfig.getString('native_poster_id');
//       _nativeSheet_2_4Id = remoteConfig.getString('native_sheet_2_4_id');
//       _nativeSheet_3_5Id = remoteConfig.getString('native_sheet_3_5_id');
//       _nativeSheet_6_8Id = remoteConfig.getString('native_sheet_6_8_id');
//       _openAppId = remoteConfig.getString('open_app_id');
//       _splashInterstitialId = remoteConfig.getString('splash_interstitial_id');

//       print('Remote config initialized');
//       print('bannerCollapsible: $_bannerCollapsible');
//       print('bannerDocument: $_bannerDocument');
//       print('bannerNotes: $_bannerNotes');
//       print('bannerPhoto: $_bannerPhoto');
//       print('bannerScan: $_bannerScan');
//       print('interstitialHome: $_interstitialHome');
//       print('nativeClipboard: $_nativeClipboard');
//       print('nativeNotes: $_nativeNotes');

//       notifyListeners();
//     } catch (e) {
//       debugPrint('Failed to fetch remote config: $e');
//     }
//   }

// }

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdConfigProvider extends ChangeNotifier {
  bool _bannerCollapsible = false;
  bool _bannerDocument = false;
  bool _bannerNotes = false;
  bool _bannerPhoto = false;
  bool _bannerScan = false;
  bool _interstitialHome = false;
  bool _nativeClipboard = false;
  bool _nativeNotes = false;
  bool _nativeOnboarding1_2 = false;
  bool _nativeOnboarding4 = false;
  bool _nativePoster = false;
  bool _nativeSheet_2_4 = false;
  bool _nativeSheet_3_5 = false;
  bool _nativeSheet_6_8 = false;
  bool _openApp = false;
  bool _splashInterstitial = false;
  bool _nativeLanguage =
      false; // New variable to track native language ad status
  bool _bannerScandoc = false; // New variable to track banner scandoc ad status
  bool _isSubscribed = false; // New variable to track subscription status

  String _bannerCollapsibleId = '';
  String _bannerDocumentId = '';
  String _bannerNotesId = '';
  String _bannerPhotoId = '';
  String _bannerScanId = '';
  String _interstitialHomeId = '';
  String _nativeClipboardId = '';
  String _nativeNotesId = '';
  String _nativeOnboarding1_2Id = '';
  String _nativeOnboarding4Id = '';
  String _nativePosterId = '';
  String _nativeSheet_2_4Id = '';
  String _nativeSheet_3_5Id = '';
  String _nativeSheet_6_8Id = '';
  String _openAppId = '';
  String _splashInterstitialId = '';
  String _nativeLanguageId = ''; // New variable to track native language ad ID
  String _bannerScandocId = ''; // New variable to track banner scandoc ad ID

  bool get isSubscribed => _isSubscribed;

  bool get bannerCollapsible => _isSubscribed ? false : _bannerCollapsible;
  bool get bannerDocument => _isSubscribed ? false : _bannerDocument;
  bool get bannerNotes => _isSubscribed ? false : _bannerNotes;
  bool get bannerPhoto => _isSubscribed ? false : _bannerPhoto;
  bool get bannerScan => _isSubscribed ? false : _bannerScan;
  bool get interstitialHome => _isSubscribed ? false : _interstitialHome;
  bool get nativeClipboard => _isSubscribed ? false : _nativeClipboard;
  bool get nativeNotes => _isSubscribed ? false : _nativeNotes;
  bool get nativeOnboarding1_2 => _isSubscribed ? false : _nativeOnboarding1_2;
  bool get nativeOnboarding4 => _isSubscribed ? false : _nativeOnboarding4;
  bool get nativePoster => _isSubscribed ? false : _nativePoster;
  bool get nativeSheet_2_4 => _isSubscribed ? false : _nativeSheet_2_4;
  bool get nativeSheet_3_5 => _isSubscribed ? false : _nativeSheet_3_5;
  bool get nativeSheet_6_8 => _isSubscribed ? false : _nativeSheet_6_8;
  bool get openApp => _isSubscribed ? false : _openApp;
  bool get splashInterstitial => _isSubscribed ? false : _splashInterstitial;
  bool get nativeLanguage => _isSubscribed
      ? false
      : _nativeLanguage; // New getter for native language ad status
  bool get bannerScandoc => _isSubscribed
      ? false
      : _bannerScandoc; // New getter for banner scandoc ad status

  String get bannerCollapsibleId => _bannerCollapsibleId;
  String get bannerDocumentId => _bannerDocumentId;
  String get bannerNotesId => _bannerNotesId;
  String get bannerPhotoId => _bannerPhotoId;
  String get bannerScanId => _bannerScanId;
  String get interstitialHomeId => _interstitialHomeId;
  String get nativeClipboardId => _nativeClipboardId;
  String get nativeNotesId => _nativeNotesId;
  String get nativeOnboarding1_2Id => _nativeOnboarding1_2Id;
  String get nativeOnboarding4Id => _nativeOnboarding4Id;
  String get nativePosterId => _nativePosterId;
  String get nativeSheet_2_4Id => _nativeSheet_2_4Id;
  String get nativeSheet_3_5Id => _nativeSheet_3_5Id;
  String get nativeSheet_6_8Id => _nativeSheet_6_8Id;
  String get openAppId => _openAppId;
  String get splashInterstitialId => _splashInterstitialId;
  String get nativeLanguageId =>
      _nativeLanguageId; // New getter for native language ad ID
  String get bannerScandocId =>
      _bannerScandocId; // New getter for banner scandoc ad ID

  AdConfigProvider() {
    print('Initializing remote config');

    _loadSubscriptionStatus();
    initializeRemoteConfig();
  }

  Future<void> _loadSubscriptionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSubscribed = prefs.getBool('isSubscribed') ?? false;
    notifyListeners();
  }

  Future<void> initializeRemoteConfig() async {
    print('Initializing remote config');
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // Use during development
      ));

      await remoteConfig.setDefaults(<String, dynamic>{
        'banner_collapsible': false,
        'banner_document': false,
        'banner_notes': false,
        'banner_photo': false,
        'banner_scan': false,
        'interstitial_home': false,
        'native_clipboard': false,
        'native_notes': false,
        'native_onboarding1_2': false,
        'native_onboarding4': false,
        'native_poster': false,
        'native_sheet_2_4': false,
        'native_sheet_3_5': false,
        'native_sheet_6_8': false,
        'open_app': false,
        'splash_interstitial': false,
        'native_language': false, // New default value for native language ad
        'banner_scandoc': false, // New default value for banner scandoc ad

        'banner_collapsible_id': 'ca-app-pub-3940256099942544/6300978111',
        'banner_document_id': 'ca-app-pub-3940256099942544/6300978111',
        'banner_notes_id': 'ca-app-pub-3940256099942544/6300978111',
        'banner_photo_id': 'ca-app-pub-3940256099942544/6300978111',
        'banner_scan_id': 'ca-app-pub-3940256099942544/6300978111',
        'interstitial_home_id': 'ca-app-pub-3940256099942544/1033173712',
        'native_clipboard_id': 'ca-app-pub-3940256099942544/2247696110',
        'native_notes_id': 'ca-app-pub-3940256099942544/2247696110',
        'native_onboarding1_2_id': 'ca-app-pub-3940256099942544/2247696110',
        'native_onboarding4_id': 'ca-app-pub-3940256099942544/2247696110',
        'native_poster_id': 'ca-app-pub-3940256099942544/2247696110',
        'native_sheet_2_4_id': 'ca-app-pub-3940256099942544/2247696110',
        'native_sheet_3_5_id': 'ca-app-pub-3940256099942544/2247696110',
        'native_sheet_6_8_id': 'ca-app-pub-3940256099942544/2247696110',
        'open_app_id': 'ca-app-pub-3940256099942544/9257395921',
        'splash_interstitial_id': 'ca-app-pub-3940256099942544/1033173712',
        'native_language_id':
            'ca-app-pub-3940256099942544/2247696110', // New default value for native language ad ID
        'banner_scandoc_id':
            'ca-app-pub-3940256099942544/6300978111', // New default value for banner scandoc ad ID
      });

      await remoteConfig.fetchAndActivate();
      print('Remote config fetched and activated');

      _bannerCollapsible = remoteConfig.getBool('banner_collapsible');
      _bannerDocument = remoteConfig.getBool('banner_document');
      _bannerNotes = remoteConfig.getBool('banner_notes');
      _bannerPhoto = remoteConfig.getBool('banner_photo');
      _bannerScan = remoteConfig.getBool('banner_scan');
      _interstitialHome = remoteConfig.getBool('interstitial_home');
      _nativeClipboard = remoteConfig.getBool('native_clipboard');
      _nativeNotes = remoteConfig.getBool('native_notes');
      _nativeOnboarding1_2 = remoteConfig.getBool('native_onboarding1_2');
      _nativeOnboarding4 = remoteConfig.getBool('native_onboarding4');
      _nativePoster = remoteConfig.getBool('native_poster');
      _nativeSheet_2_4 = remoteConfig.getBool('native_sheet_2_4');
      _nativeSheet_3_5 = remoteConfig.getBool('native_sheet_3_5');
      _nativeSheet_6_8 = remoteConfig.getBool('native_sheet_6_8');
      _openApp = remoteConfig.getBool('open_app');
      _splashInterstitial = remoteConfig.getBool('splash_interstitial');
      _nativeLanguage = remoteConfig
          .getBool('native_language'); // New value for native language ad
      _bannerScandoc = remoteConfig
          .getBool('banner_scandoc'); // New value for banner scandoc ad

      _bannerCollapsibleId = remoteConfig.getString('banner_collapsible_id');
      _bannerDocumentId = remoteConfig.getString('banner_document_id');
      _bannerNotesId = remoteConfig.getString('banner_notes_id');
      _bannerPhotoId = remoteConfig.getString('banner_photo_id');
      _bannerScanId = remoteConfig.getString('banner_scan_id');
      _interstitialHomeId = remoteConfig.getString('interstitial_home_id');
      _nativeClipboardId = remoteConfig.getString('native_clipboard_id');
      _nativeNotesId = remoteConfig.getString('native_notes_id');
      _nativeOnboarding1_2Id =
          remoteConfig.getString('native_onboarding1_2_id');
      _nativeOnboarding4Id = remoteConfig.getString('native_onboarding4_id');
      _nativePosterId = remoteConfig.getString('native_poster_id');
      _nativeSheet_2_4Id = remoteConfig.getString('native_sheet_2_4_id');
      _nativeSheet_3_5Id = remoteConfig.getString('native_sheet_3_5_id');
      _nativeSheet_6_8Id = remoteConfig.getString('native_sheet_6_8_id');
      _openAppId = remoteConfig.getString('open_app_id');
      _splashInterstitialId = remoteConfig.getString('splash_interstitial_id');
      _nativeLanguageId = remoteConfig.getString(
          'native_language_id'); // New value for native language ad ID
      _bannerScandocId = remoteConfig
          .getString('banner_scandoc_id'); // New value for banner scandoc ad ID

      print('Remote config initialized');
      print('bannerCollapsible: $_bannerCollapsible');
      print('bannerDocument: $_bannerDocument');
      print('bannerNotes: $_bannerNotes');
      print('bannerPhoto: $_bannerPhoto');
      print('bannerScan: $_bannerScan');
      print('interstitialHome: $_interstitialHome');
      print('nativeClipboard: $_nativeClipboard');
      print('nativeNotes: $_nativeNotes');
      print('splashInterstitial: $_splashInterstitial');

      notifyListeners();
    } catch (e) {
      print('Error initializing remote config: $e');
    }
  }

  Future<void> updateSubscriptionStatus(bool isSubscribed) async {
    _isSubscribed = isSubscribed;
    // Save subscription status in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSubscribed', isSubscribed);
    // Update all ad flags to false if subscribed
    _bannerCollapsible = !isSubscribed;
    _bannerDocument = !isSubscribed;
    _bannerNotes = !isSubscribed;
    _bannerPhoto = !isSubscribed;
    _bannerScan = !isSubscribed;
    _interstitialHome = !isSubscribed;
    _nativeClipboard = !isSubscribed;
    _nativeNotes = !isSubscribed;
    _nativeOnboarding1_2 = !isSubscribed;
    _nativeOnboarding4 = !isSubscribed;
    _nativePoster = !isSubscribed;
    _nativeSheet_2_4 = !isSubscribed;
    _nativeSheet_3_5 = !isSubscribed;
    _nativeSheet_6_8 = !isSubscribed;
    _openApp = !isSubscribed;
    _splashInterstitial = !isSubscribed;
    _nativeLanguage = !isSubscribed; // Update native language ad flag
    _bannerScandoc = !isSubscribed; // Update banner scandoc ad flag

    notifyListeners(); // Notify listeners that subscription status has changed
  }

  // Check subscription status for each ad type
  bool checkAdCollapsible() => _isSubscribed ? false : _bannerCollapsible;
  bool checkAdDocument() => _isSubscribed ? false : _bannerDocument;
  bool checkAdNotes() => _isSubscribed ? false : _bannerNotes;
  bool checkAdPhoto() => _isSubscribed ? false : _bannerPhoto;
  bool checkAdScan() => _isSubscribed ? false : _bannerScan;
  bool checkInterstitialHome() => _isSubscribed ? false : _interstitialHome;
  bool checkNativeClipboard() => _isSubscribed ? false : _nativeClipboard;
  bool checkNativeNotes() => _isSubscribed ? false : _nativeNotes;
  bool checkNativeOnboarding1_2() =>
      _isSubscribed ? false : _nativeOnboarding1_2;
  bool checkNativeOnboarding4() => _isSubscribed ? false : _nativeOnboarding4;
  bool checkNativePoster() => _isSubscribed ? false : _nativePoster;
  bool checkNativeSheet_2_4() => _isSubscribed ? false : _nativeSheet_2_4;
  bool checkNativeSheet_3_5() => _isSubscribed ? false : _nativeSheet_3_5;
  bool checkNativeSheet_6_8() => _isSubscribed ? false : _nativeSheet_6_8;
  bool checkOpenApp() => _isSubscribed ? false : _openApp;
  bool checkSplashInterstitial() => _isSubscribed ? false : _splashInterstitial;
  bool checkNativeLanguage() => _isSubscribed
      ? false
      : _nativeLanguage; // Check native language ad status
  bool checkBannerScandoc() =>
      _isSubscribed ? false : _bannerScandoc; // Check banner scandoc ad status
}
