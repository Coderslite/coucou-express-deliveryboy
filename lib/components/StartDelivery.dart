import 'package:flutter/material.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/screen/DashboardScreen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screen/track_order/DeliveryInProgress.dart';
import '../utils/Colors.dart';

handleStartDelivery(
    {required OrderModel order,
    required bool isConfirmed,
    required BuildContext context}) async {
  showInDialog(
      barrierDismissible: false,
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isConfirmed ? "Delivery Confirmed" : "Awaiting Customer Response",
            style: boldTextStyle(size: 18),
          ),
          Text(
            isConfirmed
                ? "Please wait while your customer makes confirmation"
                : "Your Customer has confirmed the delivery now you can start the delivery.",
            textAlign: TextAlign.center,
            style: secondaryTextStyle(size: 12),
          ),
          SizedBox(
            width: 150,
            height: 150,
            child: Image.asset(
              "images/delivery_confirmed.png",
              fit: BoxFit.cover,
            ),
          ),
          10.height,
          AppButton(
            onTap: () {
              isConfirmed
                  ? DeliveryInProgress(
                      order: order,
                    ).launch(context)
                  : DashboardScreen().launch(context);
            },
            text: isConfirmed ? "Start Delivery" : "OK",
            color: primaryColor,
            width: double.infinity,
            textColor: white,
          )
        ],
      ));
}
