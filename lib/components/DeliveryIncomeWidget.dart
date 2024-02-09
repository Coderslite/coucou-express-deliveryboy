import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/screen/OrderDetailScreen.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class DeliveryIncomeWidget extends StatefulWidget {
  final OrderModel? orderData;

  DeliveryIncomeWidget({this.orderData});

  @override
  DeliveryIncomeWidgetState createState() => DeliveryIncomeWidgetState();
}

class DeliveryIncomeWidgetState extends State<DeliveryIncomeWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: appStore.isDarkMode ? scaffoldColorDark : white,
      highlightColor: appStore.isDarkMode ? scaffoldColorDark : white,
      onTap: () {
        OrderDetailScreen(orderModel: widget.orderData).launch(context);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(16),
        width: context.width(),
        decoration: boxDecorationRoundedWithShadow(12,
            backgroundColor: context.cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.orderData!.restaurantName!.isEmpty
                    ? widget.orderData!.orderType!
                    : widget.orderData!.restaurantName!,
                style: boldTextStyle(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.orderData!.deliveryCharge != null
                        ? Text(appStore.translate('delivery_charge'),
                            style: secondaryTextStyle())
                        : SizedBox(),
                    8.height,
                    Text(getAmount(widget.orderData!.deliveryCharge!),
                        style: boldTextStyle()),
                  ],
                ),
                8.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(appStore.translate('total'),
                        style: secondaryTextStyle()),
                    4.height,
                    Text(getAmount(widget.orderData!.totalAmount!),
                        style: boldTextStyle()),
                  ],
                ),
              ],
            ),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.access_time_rounded, color: grayColor, size: 18),
                8.width,
                Text(
                    DateFormat('EEE d, MMM yyyy HH:mm')
                        .format(widget.orderData!.createdAt!),
                    style: secondaryTextStyle()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
