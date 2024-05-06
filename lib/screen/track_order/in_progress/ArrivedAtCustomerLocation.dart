import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/Colors.dart';

class ArrivedAtCustomerLocation extends StatelessWidget {
  const ArrivedAtCustomerLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "You’re arrived at the customer’s location please add a cash payment proof via image and delivery proof to complete your delivery.",
          style: primaryTextStyle(
            size: 12,
          ),
        ),
        10.height,
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Divider(),
                Expanded(
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Item ${index + 1}",
                                style: primaryTextStyle(
                                  size: 16,
                                ),
                              ),
                              Text(
                                "Item ${index + 1}",
                                style: primaryTextStyle(
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                10.height,
                Divider(),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: boldTextStyle(
                        size: 16,
                      ),
                    ),
                    Text(
                      "\$24.56",
                      style: boldTextStyle(
                        size: 16,
                      ),
                    ),
                  ],
                ),
                10.height,
              ],
            ),
          ),
        ),
        20.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 60,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryColor,
                ),
              ),
              child: Text(
                "Payment Proof",
                style: boldTextStyle(
                  size: 14,
                  color: primaryColor,
                ),
              ),
            ),
            Container(
              height: 60,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryColor,
                ),
              ),
              child: Text(
                "Delivery Proof",
                style: boldTextStyle(
                  size: 14,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        20.height,
      ],
    );
  }
}
