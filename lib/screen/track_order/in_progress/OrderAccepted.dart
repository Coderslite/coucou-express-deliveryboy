import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderAccepted extends StatelessWidget {
  const OrderAccepted({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "You have successfully accepted the order. To move forward with the order please click on the Arrived button below.",
      style: primaryTextStyle(
        size: 12,
      ),
    );
  }
}
