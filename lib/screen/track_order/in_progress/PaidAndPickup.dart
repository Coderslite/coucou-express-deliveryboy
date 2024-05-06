import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PaidAndPickup extends StatefulWidget {
  const PaidAndPickup({super.key});

  @override
  State<PaidAndPickup> createState() => _PaidAndPickupState();
}

class _PaidAndPickupState extends State<PaidAndPickup> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Order has been and picked up. Your next destination is customer’s address. Please click on the button below to arrive at the customer location.Order has been and picked up. Your next destination is customer’s address. Please click on the button below to arrive at the customer location.",
      style: primaryTextStyle(
        size: 12,
      ),
    );
  }
}
