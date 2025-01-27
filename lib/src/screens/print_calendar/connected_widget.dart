import 'package:flutter/material.dart';
import 'package:printer_app/src/screens/print_calendar/text_button_widget.dart';
import 'package:printer_app/src/screens/print_calendar/yearly_list_widget.dart';
import 'monthly_list_widget.dart';


class ConnectedWidget extends StatefulWidget {
  const ConnectedWidget({super.key});

  @override
  State<ConnectedWidget> createState() => _ConnectedWidgetState();
}

class _ConnectedWidgetState extends State<ConnectedWidget> {
  String selectedtype = 'Month';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButtonWidget(
                onTap: () {
                  setState(() {
                    selectedtype = 'Month';
                  });
                },
                text: 'Month',
                isSelected: selectedtype == 'Month',
              ),
              SizedBox(width: 80),
              TextButtonWidget(
                onTap: () {
                  setState(() {
                    selectedtype = 'Year';
                  });
                },
                text: 'Year',
                isSelected: selectedtype == 'Year',
              ),
            ],
          ),

          SizedBox(height: 15),

          // Main Body
          selectedtype == 'Month' ? MonthlyListWidget() : YearlyListWidget(),
        ],
      ),
    );
  }
}
