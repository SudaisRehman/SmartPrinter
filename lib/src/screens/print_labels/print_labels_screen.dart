import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../not_connected_widget.dart';
import 'label_connected_widget.dart';


class PrintLabelsScreen extends StatefulWidget {
  const PrintLabelsScreen({super.key});

  @override
  State<PrintLabelsScreen> createState() => _PrintLabelsScreenState();
}

class _PrintLabelsScreenState extends State<PrintLabelsScreen> {
  bool isConnected = true;
  StreamSubscription? internetConnectionStreamSubs;

  @override
  void initState() {
    internetConnectionStreamSubs = InternetConnection().onStatusChange.listen((event) {

      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnected = true;
          });

          break;

        case InternetStatus.disconnected:
          setState(() {
            isConnected = false;
          });

          break;

        default:
          setState(() {
            isConnected = false;
          });

          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    internetConnectionStreamSubs?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Labels',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: isConnected ? LabelConnectedWidget() : NotConnectedWidget(),
      ),
    );
  }
}
