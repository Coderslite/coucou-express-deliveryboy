import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/model/UserModel.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/Constants.dart';
import 'AppWidgets.dart';
import 'RestaurantInfoBottomSheet.dart';

class PendingOrderItemWidget extends StatefulWidget {
  final OrderModel? orderData;
  final Function? onAccept;
  final int index;

  PendingOrderItemWidget({this.orderData, this.onAccept, required this.index});

  @override
  PendingOrderItemWidgetState createState() => PendingOrderItemWidgetState();
}

class PendingOrderItemWidgetState extends State<PendingOrderItemWidget> {
  AsyncMemoizer<UserModel> userMemoizer = AsyncMemoizer();
  int? timeRemainingInSeconds;
  @override
  void initState() {
    super.initState();
    init();

    // Calculate the time remaining in seconds
  }

  Future<void> init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: userMemoizer.runOnce(
          () => userService.getUserById(userId: widget.orderData!.userId)),
      builder: (_, snap) {
        if (snap.hasError) {
          return Center(
            child: Text(
              snap.error.toString() + widget.orderData!.userId.toString(),
              style: primaryTextStyle(),
            ),
          );
        } else if (snap.hasData) {
          UserModel? data = snap.data;
          return Container(
            decoration: boxDecorationRoundedWithShadow(12,
                backgroundColor: context.cardColor),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // StreamBuilder(
                //     stream: FirebaseFirestore.instance
                //         .collection("orders")
                //         .doc(widget.orderData!.id)
                //         .snapshots(),
                //     builder: (context, snapshot) {
                //       if (snapshot.hasError) {
                //         return Center(child: Text("Something went wrong"));
                //       } else if (snapshot.hasData) {
                //         var data = snapshot.data!.data();
                //         final Timestamp orderTimestamp =
                //             data!['acceptOrderTimeRemaining'];
                //         final DateTime currentTime = DateTime.now();
                //         final DateTime orderTime = orderTimestamp.toDate();
                //         final int secondsRemaining =
                //             orderTime.isAfter(currentTime)
                //                 ? orderTime.difference(currentTime).inSeconds
                //                 : 0;
                //         return Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text("Accept Time remaining",
                //                 style: boldTextStyle()),
                //             SlideCountdown(
                //               curve: Curves.decelerate,
                //               streamDuration: StreamDuration(
                //                   Duration(seconds: secondsRemaining)),
                //               showZeroValue: true,
                //               shouldShowDays: (context) {
                //                 return false;
                //               },
                //               separator: ':',
                //               // duration: Duration(seconds: secondsRemaining),
                //             ),
                //           ],
                //         );
                //       } else {
                //         return Text("");
                //       }
                //     }),

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
                      Text('${data!.name.validate()}',
                              style: primaryTextStyle(size: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)
                          .expand(),
                      Icon(Icons.access_time_rounded,
                          color: grayColor, size: 18),
                      4.width,
                      widget.orderData!.createdAt!.isToday
                          ? Text(
                              DateFormat.jm()
                                  .format(widget.orderData!.createdAt!),
                              style: secondaryTextStyle(size: 13))
                          : Text(
                              DateFormat('dd/MM/yyyy\nhh:mm a')
                                  .format(widget.orderData!.createdAt!),
                              style: secondaryTextStyle(size: 10),
                              textAlign: TextAlign.right),
                    ],
                  ),
                8.height,
                if (snap.hasData)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.call, color: blueButtonColor).onTap(() {
                        launch('tel://${data!.number.validate()}');
                      }),
                      8.width,
                      Text(data!.number.validate(),
                          style: primaryTextStyle(size: 15)),
                    ],
                  ),
                4.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.home, color: blueButtonColor),
                    4.width,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                          widget.orderData!.deliveryLocation == 'Inside UCAD'
                              ? widget.orderData!.pavilionNo!
                              : widget.orderData!.deliveryAddresss.validate(),
                          style: secondaryTextStyle(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text("(${widget.orderData!.deliveryLocation.validate()})",
                        style: secondaryTextStyle(color: primaryColor),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis)
                  ],
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(
                      enabled:
                          widget.index == 0 && getBoolAsync(AVAILABLE) == true,
                      onTap: () async {
                        widget.onAccept?.call();
                      },
                      child: Text(appStore.translate('accept'),
                          style: boldTextStyle(color: Colors.white)),
                      color: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.info_outline,
                              size: 25, color: blueButtonColor),
                          onPressed: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16))),
                              context: context,
                              builder: (BuildContext context) {
                                return RestaurantInfoBottomSheet(
                                    widget.orderData);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        } else {
          return Center(
            child: Loader(),
          );
        }
      },
    );
  }
}
