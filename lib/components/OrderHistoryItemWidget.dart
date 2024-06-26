import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/model/UserModel.dart';
import 'package:food_delivery/screen/OrderDetailScreen.dart';
import 'package:food_delivery/screen/track_order/OrderChat.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AppWidgets.dart';

class OrderHistoryItemWidget extends StatefulWidget {
  final OrderModel? orderData;

  OrderHistoryItemWidget(this.orderData);

  @override
  OrderHistoryItemWidgetState createState() => OrderHistoryItemWidgetState();
}

class OrderHistoryItemWidgetState extends State<OrderHistoryItemWidget> {
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
    return FutureBuilder<UserModel>(
      future: userService.getUserById(userId: widget.orderData!.userId),
      builder: (_, snap) {
        UserModel? data = snap.data;
        bool isToday = false;

        if (snap.hasData) {
          isToday = DateTime.now().day == data!.createdAt!.day;
        }

        return InkWell(
          onTap: () {
            // OrderDetailScreen(
            //   orderModel: widget.orderData,
            // ).launch(context);

            OrderChatScreen(
              order: widget.orderData!,
            ).launch(context);
          },
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            decoration: boxDecorationRoundedWithShadow(12,
                backgroundColor: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    orderStatusWidget(widget.orderData!.orderStatus)
                        .flexible(fit: FlexFit.loose),
                    Text('#${widget.orderData!.orderId}',
                        style: boldTextStyle(size: 10)),
                  ],
                ),
                8.height,
                if (snap.hasData)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${data!.name}',
                              style: primaryTextStyle(size: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)
                          .expand(),
                      Icon(Icons.access_time_rounded,
                          color: grayColor, size: 18),
                      4.width,
                      isToday
                          ? Text(
                              DateFormat.jm().format(DateTime.parse(
                                  widget.orderData!.createdAt.toString())),
                              style: secondaryTextStyle(size: 13))
                          : Text(
                              DateFormat('dd/MM/yyyy\nhh:mm a')
                                  .format(widget.orderData!.createdAt!),
                              style: secondaryTextStyle(size: 10),
                              textAlign: TextAlign.right)
                    ],
                  ),
                8.height,
                if (snap.hasData)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.call, color: blueButtonColor.withOpacity(0.6))
                          .onTap(() {
                        launch('tel://${data!.number.validate()}');
                      }),
                      8.width,
                      Text(data!.number.validate(),
                              style: primaryTextStyle(size: 15))
                          .onTap(() {
                        launch('tel://${data.number.validate()}');
                      }),
                    ],
                  ),
                4.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.home, color: blueButtonColor.withOpacity(0.6)),
                    4.width,
                    Text(
                            widget.orderData!.deliveryLocation == "Inside UCAD"
                                ? widget.orderData!.pavilionNo!
                                : widget.orderData!.deliveryAddresss!,
                            style: secondaryTextStyle(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis)
                        .expand()
                  ],
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      onTap: () async {
                        // await TrackingScreen(orderModel: widget.orderData)
                        //     .launch(context)
                        //     .catchError((e) {
                        //   log(e.toString());
                        // });
                      },
                      child: Text(appStore.translate('track'),
                          style: boldTextStyle(color: Colors.white)),
                      color: primaryColor,
                    ).visible(false),
                  ],
                )
              ],
            ).paddingOnly(left: 10, right: 10, top: 8, bottom: 8),
          ),
        );
      },
    );
  }
}
