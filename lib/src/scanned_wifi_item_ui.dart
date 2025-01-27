import 'package:flutter/material.dart';
import 'package:printer_app/src/providers/RemoteConfigProvider.dart';
import 'package:printer_app/src/widgets/subscription_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/printer_model.dart';

class ScannedWifiItemUi extends StatefulWidget {
  final PrintModel printModel;

  // final VoidCallback onPressed;

  final void Function(PrintModel item) onConnectPressed;

  // This is the type of service we're looking for :
  // final String type = '_wonderful-service._tcp';

  const ScannedWifiItemUi(
      {super.key, required this.printModel, required this.onConnectPressed});

  @override
  State<ScannedWifiItemUi> createState() => _ScannedWifiItemUiState();
}

class _ScannedWifiItemUiState extends State<ScannedWifiItemUi> {
  bool _hasUsedFreePrint = false;
  Future<void> _loadFreePrintStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasUsedFreePrint = prefs.getBool('hasUsedFreePrint') ?? false;
    });
  }

  Future<void> _setFreePrintUsed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasUsedFreePrint', true);
    setState(() {
      _hasUsedFreePrint = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFreePrintStatus();
  }

  @override
  Widget build(BuildContext context) {
    final adConfigProvider =
        Provider.of<AdConfigProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFF17BDD3),
      ),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      margin: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.printModel.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.only(top: 7, bottom: 7, right: 10),
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 8,
                bottom: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  if (!adConfigProvider.isSubscribed || _hasUsedFreePrint) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubscriptionPage()),
                    );
                  } else {
                    late PrintModel localPrintModel;
                    localPrintModel = widget.printModel.isConnected
                        ? PrintModel(
                            title: widget.printModel.title, isConnected: false)
                        : PrintModel(
                            title: widget.printModel.title, isConnected: true);

                    widget.onConnectPressed(localPrintModel);
                  }
                },
                child: Text(
                  widget.printModel.isConnected ? "Connected" : "Connect",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: Color(0xFF17BDD3),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
