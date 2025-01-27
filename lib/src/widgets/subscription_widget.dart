import 'package:flutter/material.dart';
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
      "You will be charged \$2.99 every week",
      "The subscription auto-renews and you can cancel it anytime.",
      "To manage or cancel your subscription, go to your Google Play Store account > Payments and subscriptions > Subscriptions.",
      "Limited usage of the app is available without a subscription.",
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
      backgroundColor: AppColor.lightBlueBg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    // adConfig.updateSubscriptionStatus(true);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeWidget(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.cancel,
                    color: Colors.grey.withOpacity(.5),
                    size: 30,
                  ),
                ),
              ],
            ),
            Text(
              "Connect Smart Printer\n& Scanner",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            SizedBox(height: 20),
            Text(
              "Try 3 Days Free, then \$12.99/Month",
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 10),
            _buildFeatureBox(),
            SizedBox(height: 24),
            _buildContinueButton(),
            SizedBox(height: 16),
            Text(
              "No Commitment / Cancel Anytime",
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 8),
            _buildTermsAndPrivacyPolicy(),
            SizedBox(height: 16),
            ..._buildNotes(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionOption(
      String packageTitle, String title, String price, String period) {
    bool isSelected = selectedSubscription == title;

    double selectedHeight = 140;
    double unselectedHeight = 130;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSubscription = title;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isSelected ? selectedHeight : unselectedHeight,
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                packageTitle,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 4),
              Text(
                price,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              Text(
                period,
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBox() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureItem(1, "- Easy Printer Connectivity"),
          _buildFeatureItem(2, "- Print your Photos"),
          _buildFeatureItem(3, "- Print your Saved Files"),
          _buildFeatureItem(4, "- Scan Document & Photos"),
          _buildFeatureItem(5, "- Print Documents & Photos in any size"),
        ],
      ),
    );
  }

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
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 16,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                note,
                style: TextStyle(fontSize: 12, color: Colors.black),
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
        color: AppColor.lightBlueColor,
        borderRadius: BorderRadius.circular(10),
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
            top: 8,
            bottom: 8,
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
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        SizedBox(width: 8),
        Container(width: 2, height: 17, color: Colors.red),
        SizedBox(width: 8),
        Text(
          "Privacy Policy",
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}
