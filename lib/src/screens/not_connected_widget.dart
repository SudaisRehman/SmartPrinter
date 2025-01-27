import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class NotConnectedWidget extends StatelessWidget {
  const NotConnectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'icons/new/wifi_icon.webp',
              width: 45,
            ),
            SizedBox(height: 10),
            Text(
              'No WiFi or Data Network',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 1),
            Text(
              'This device is not connected to WiFi or Data Network right now. Make sure it’s connected so that you can use the smart printer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () => AppSettings.openAppSettings(type: AppSettingsType.wifi),
              child: Container(
                height: 35,
                width: 250,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff17BDD3),
                ),
                child: Center(
                  child: Text(
                    'Connect to WiFi or Data Network',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.white,
                    ),
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