import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:printer_app/Constants/Constant.dart';
import 'package:printer_app/firebase_options.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/providers/appProvider.dart';
import 'package:printer_app/src/providers/languages_provider.dart';
import 'package:printer_app/src/providers/nav_bar_provider.dart';
import 'package:printer_app/src/providers/on_boarding_provider.dart';
import 'package:printer_app/src/screens/home_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:printer_app/src/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

WebViewEnvironment? webViewEnvironment;

Future main() async {
  // runApp(const MyApp());
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  // Get Locale Value
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('language_code');

  Locale initialLocale =
      languageCode != null ? Locale(languageCode) : const Locale('en');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AdConfigProvider adConfigProvider = AdConfigProvider();
  // await adConfigProvider.initializeRemoteConfig();
  // await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //   apiKey: 'key',
  //   appId: 'id',
  //   messagingSenderId: 'sendid',
  //   projectId: 'myapp',
  //   storageBucket: 'myapp-b9yt18.appspot.com',
  // ));

  /*web view*/
  // await Permission.camera.request();
  // await Permission.microphone.request();
  // await Permission.storage.request();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    assert(availableVersion != null,
        'Failed to find an installed WebView2 runtime or non-stable Microsoft Edge installation.');

    webViewEnvironment = await WebViewEnvironment.create(
        settings: WebViewEnvironmentSettings(userDataFolder: 'custom_path'));
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  /*web view*/

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LanguagesProvider(initialLocale),
        ),
        ChangeNotifierProvider(create: (context) => OnBoardingProvider()),
        ChangeNotifierProvider(create: (context) => NavBarProvider()),
        ChangeNotifierProvider(
          create: (_) => AdConfigProvider(), // Initialize AdConfigProvider
        ),
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

AppOpenAd? _appOpenAd;
bool _isShowingAd = false;
bool _hasAdBeenShown = false;

void loadAds(BuildContext context) async {
  final adConfig = Provider.of<AdConfigProvider>(context, listen: false);

  AppOpenAd.load(
    adUnitId: adConfig.openAppId, // Replace with your ad unit ID
    request: const AdRequest(),
    adLoadCallback: AppOpenAdLoadCallback(
      onAdLoaded: (ad) {
        _appOpenAd = ad;
        print('App open ad loaded successfully.');
      },
      onAdFailedToLoad: (error) {
        print('Failed to load app open ad: $error');
        // Retry after a delay
        Future.delayed(const Duration(seconds: 30), () => loadAds(context));
      },
    ),
  );
}

void showAppOpenAd(BuildContext context) {
  if (_appOpenAd == null || _isShowingAd) return;

  _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (ad) {
      print('Ad dismissed.');
      _isShowingAd = false;
      _hasAdBeenShown = false; // Reset the flag to allow future ads
      ad.dispose();
      loadAds(context); // Preload the next ad
    },
    onAdFailedToShowFullScreenContent: (ad, error) {
      print('Failed to show ad: $error');
      _isShowingAd = false;
      ad.dispose();
      loadAds(context); // Preload the next ad
    },
  );

  _isShowingAd = true;
  _hasAdBeenShown = true; // Mark as shown to prevent immediate retries
  _appOpenAd!.show();
  print('App open ad shown.');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _wasInBackground = false;
  InterstitialAd? _interstitialAd;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initialization();
    _loadInterstitialAd();
    loadAds(context);
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  bool isInterstitialAdLoaded = false;

  void _loadInterstitialAd() async {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    await adConfig.initializeRemoteConfig();
    // await Future.delayed(Duration(seconds: 2));
    await InterstitialAd.load(
      adUnitId: adConfig.splashInterstitialId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            isInterstitialAdLoaded = true;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _loadInterstitialAd(); // Load a new interstitial ad
            },
            onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
              ad.dispose(); // Dispose if it fails to show
              _loadInterstitialAd(); // Load a new interstitial ad
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load interstitial ad: $error');
          isInterstitialAdLoaded = false;
          // Retry loading the ad after a delay or log the error
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final adConfig = Provider.of<AdConfigProvider>(context, listen: false);
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (_wasInBackground) {
        _wasInBackground = false;

        if (_appOpenAd != null && adConfig.openApp) {
          showAppOpenAd(context);
        } else {
          loadAds(context); // Ensure ad is loaded if not already available
        }
      }
    } else if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  // @override
  // dispose() {
  //   //close the database
  //   noteDatabase.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final languagesProvider = Provider.of<LanguagesProvider>(context);
    log('Locale: ${languagesProvider.appLocale}');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: languagesProvider.appLocale,
      // locale: const Locale('en'),
      home: SplashScreen(
        interstitialAd: _interstitialAd,
      ),
      // home: HomeWidget(),
    );
  }
}
