import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:printer_app/src/screens/home_widget.dart';
import 'package:provider/provider.dart';
import '../providers/RemoteConfigProvider.dart';
import '../utils/colors.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedSubscription = "Weekly"; // Default selected option
  late InAppPurchase _inAppPurchase;
  List<ProductDetails> _products = [];
  bool _isPlayStoreAvailable = true;

  final Map<String, List<String>> subscriptionNotes = {
    "Weekly": [
      "The user and auto renewal may manage subscription that may be turned off by going to the  user’s account settings after purchase",
      "The user and auto renewal may manage subscription that may be turned off by going to the  user’s account settings after purchase",
      "The user and auto renewal may manage subscription that may be turned off by going to the  user’s account settings after purchase",
      "Any unused portion of a free trial period, if offered, will be forfeited when the user purchase a subscription to that publication, where applicable.",
      "Account will be charged for renewal within  24 hours before the end of the current period, and identify the renewal cost."
    ],
    "Monthly": [
      "Trails start on September 22, 2024, and end on September 28, 2024.",
      "Due amount today: \$0.00.",
      "Google will notify you before the trial ends.",
      "You can cancel anytime before the trial ends to avoid being charged.",
      "After the trial ends, you will be automatically charged \$12.99 every month.",
      "The subscription auto-renews and you can cancel it anytime.",
      "To manage or cancel your subscription, go to your Google Play Store account > Payments and subscriptions > Subscriptions.",
      "Limited usage of the app is available without a subscription.",
    ],
    "Yearly": [
      "You will be charged \$99.99 every year.",
      "The subscription auto-renews and you can cancel it anytime.",
      "To manage or cancel your subscription, go to your Google Play Store account > Payments and subscriptions > Subscriptions.",
      "Limited usage of the app is available without a subscription.",
    ],
  };

  @override
  void initState() {
    super.initState();
    _inAppPurchase = InAppPurchase.instance;
    _initPurchase();
  }

  Future<void> _initPurchase() async {
    final bool available = await _inAppPurchase.isAvailable();
    setState(() {
      _isPlayStoreAvailable = available;
    });

    if (available) {
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails({
        'com.yourapp.weekly_subscription',
        'com.yourapp.monthly_subscription',
        'com.yourapp.yearly_subscription',
      });
      setState(() {
        _products = response.productDetails;
      });
    }
  }

  void _purchaseProduct(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    final adConfigProvider = Provider.of<AdConfigProvider>(context);

    // Use demo products if Play Store products are not available
    final List<Map<String, String>> demoProducts = [
      {
        "title": "Weekly Plan",
        "id": "Weekly",
        "price": "\$2.99",
        "period": "/week",
      },
      {
        "title": "Monthly Plan",
        "id": "Monthly",
        "price": "\$12.99",
        "period": "/month",
      },
      {
        "title": "Yearly Plan",
        "id": "Yearly",
        "price": "\$99.99",
        "period": "/year",
      },
    ];
    final adConfig = Provider.of<AdConfigProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Image(
              image: AssetImage(
                "icons/premiumprinter.png",
              ),
              // width: double.infinity,
            ),
            Positioned(
                top: 100,
                child: Image(image: AssetImage("icons/printeroverlay.png"))),
            Padding(
              padding: const EdgeInsets.only(
                top: 200,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         // adConfig.updateSubscriptionStatus(true);
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => HomeWidget(),
                  //           ),
                  //         );
                  //       },
                  //       child: Icon(
                  //         Icons.cancel,
                  //         color: Colors.grey.withOpacity(.5),
                  //         size: 30,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Text(
                    "SMART PRINTER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 35,
                      // height: 1.5,
                      fontFamily: 'popins',
                      color: Color(0xff00353A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(height: 8),
                  Text(
                    'Unleash all PRO Features',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'popins',
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ScrollWidget(
                          iconpath: "icons/connectprinter.svg",
                          boldtext: "Connect to",
                          normaltext: "all printers",
                        ),
                        SizedBox(width: 10),
                        ScrollWidget(
                          iconpath: "icons/unlimetdprint.svg",
                          boldtext: "Unlimited",
                          normaltext: "Printables",
                        ),
                        SizedBox(width: 10),
                        ScrollWidget(
                          iconpath: 'icons/noads.svg',
                          boldtext: "Ad Free",
                          normaltext: "Version",
                        ),
                        SizedBox(width: 10),
                        ScrollWidget(
                          iconpath: 'icons/printephotos.svg',
                          boldtext: "Print Photos",
                          normaltext: "& labels",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Continue with free trial',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'popins',
                        decoration: TextDecoration.underline,
                      )),
                  SizedBox(height: 10),

                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: (_isPlayStoreAvailable && _products.isNotEmpty)
                        ? _products.map((product) {
                            return _buildSubscriptionOption(
                              product.title,
                              product.id,
                              "\$${product.price}",
                              "/month",
                            );
                          }).toList()
                        : demoProducts.map((product) {
                            return _buildSubscriptionOption(
                              product["title"]!,
                              product["id"]!,
                              product["price"]!,
                              product["period"]!,
                            );
                          }).toList(),
                  ),
                  _buildContinueButton(),
                  Text(
                    "No Commitment / Cancel Anytime",
                    style: TextStyle(fontSize: 14, color: Color(0xff379000)),
                  ),
                  // SizedBox(height: 20),
                  // Text(
                  //   "Try 3 Days Free, then \$12.99/Month",
                  //   style: TextStyle(fontSize: 14, color: Colors.black),
                  // ),
                  SizedBox(height: 8),
                  _buildTermsAndPrivacyPolicy(),
                  // SizedBox(height: 10),
                  // _buildFeatureBox(),
                  // SizedBox(height: 24),

                  // SizedBox(height: 16),

                  //

                  SizedBox(height: 10),
                  ..._buildNotes(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionOption(
      String packageTitle, String title, String price, String period) {
    bool isSelected = selectedSubscription == title;

    double selectedHeight = 70;
    double unselectedHeight = 70;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSubscription = title;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: isSelected ? selectedHeight : unselectedHeight,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              packageTitle,
              style: TextStyle(
                  fontFamily: 'popins',
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.black : Color(0xff898383),
                  fontSize: 16),
            ),
            // SizedBox(width: 50),
            Row(
              children: [
                // Text(
                //   title,
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //     fontFamily: 'popins',
                //     color: isSelected ? Colors.black : Color(0xff898383),
                //   ),
                // ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : Color(0xff898383),
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 18,
                    color: isSelected ? Colors.black : Color(0xff898383),
                  ),
                ),
              ],
            ),

            // SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  // Widget _buildFeatureBox() {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.transparent, width: 2),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.3),
  //           spreadRadius: 2,
  //           blurRadius: 5,
  //           offset: Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildFeatureItem(1, "- Easy Printer Connectivity"),
  //         _buildFeatureItem(2, "- Print your Photos"),
  //         _buildFeatureItem(3, "- Print your Saved Files"),
  //         _buildFeatureItem(4, "- Scan Document & Photos"),
  //         _buildFeatureItem(5, "- Print Documents & Photos in any size"),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFeatureItem(int count, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$count ",
            style: TextStyle(color: Colors.teal),
          ),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNotes() {
    List<String> notes = subscriptionNotes[selectedSubscription]!;
    return notes.map((note) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            // Icon(
            //   Icons.check_circle,
            //   color: Colors.green,
            //   size: 16,
            // ),
            // SizedBox(width: 4),
            Expanded(
              child: Text(
                note,
                style: TextStyle(
                    fontSize: 10, fontFamily: 'popins', color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildContinueButton() {
    final adConfig = Provider.of<AdConfigProvider>(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        color: Color(0xff54A0F6),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: () {
          adConfig.updateSubscriptionStatus(true);

          if (_products.isNotEmpty) {
            _purchaseProduct(_products.first);
          }
        },
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: 16,
          ),
          child: Text(
            "Continue",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacyPolicy() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Term of use",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            decoration: TextDecoration.underline,
          ),
        ),
        SizedBox(width: 8),
        Container(width: 2, height: 17, color: Colors.black),
        SizedBox(width: 8),
        Text(
          "Privacy Policy",
          style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              decoration: TextDecoration.underline),
        ),
      ],
    );
  }
}

class ScrollWidget extends StatelessWidget {
  final String iconpath;
  final String boldtext;
  final String normaltext;

  const ScrollWidget({
    super.key,
    required this.iconpath,
    required this.boldtext,
    required this.normaltext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconpath,
              width: 20,
              height: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  boldtext,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  normaltext,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
