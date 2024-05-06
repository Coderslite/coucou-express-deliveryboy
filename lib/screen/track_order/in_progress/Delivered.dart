import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class Delivered extends StatelessWidget {
  const Delivered({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Congratulations! You’ve successfully delivered the order. Please click on Done button below to mark your delivery as completed.",
      style: primaryTextStyle(
        size: 12,
      ),
    );
  }
}
