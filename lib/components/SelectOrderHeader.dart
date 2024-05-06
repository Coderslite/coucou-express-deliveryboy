import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/model/UserModel.dart';
import 'package:food_delivery/screen/track_order/OrderChat.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/Colors.dart';
import 'package:timeago/timeago.dart' as timeago;

selectOrderHeader(BuildContext context,
    {required bool inProgress, required OrderModel order}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
            color: context.cardColor, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      "images/radio.png",
                      fit: BoxFit.cover,
                    )),
                5.width,
                Text(
                  "Order Registration",
                  style: boldTextStyle(
                    size: 16,
                    color: primaryColor,
                  ),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      "images/radio.png",
                      fit: BoxFit.cover,
                      color: inProgress
                          ? primaryColor
                          : primaryColor.withOpacity(0.4),
                    )),
                5.width,
                Text(
                  "Delivery Process",
                  style: boldTextStyle(
                    size: 16,
                    color: inProgress
                        ? primaryColor
                        : primaryColor.withOpacity(0.4),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      10.height,
      StreamBuilder<UserModel>(
          stream: userService.getUserById2(userId: order.userId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var user = snapshot.data!;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: user.photoUrl.isEmptyOrNull
                          ? Image.asset(
                              "images/avatar.png",
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: user.photoUrl.validate(),
                              fit: BoxFit.cover,
                            ),
                    ),
                    10.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name.validate(),
                            style: boldTextStyle(
                              size: 14,
                            ),
                          ),
                          10.height,
                          Row(
                            children: [
                              Container(
                                height: 30,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "images/call.png",
                                  fit: BoxFit.cover,
                                ),
                              ).onTap(() {
                                launch('tel:${user.number}');
                              }),
                              10.width,
                              Container(
                                height: 30,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "images/message.png",
                                  fit: BoxFit.cover,
                                ),
                              ).onTap(() {
                                OrderChatScreen(order: order).launch(context);
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          timeago.format(order.createdAt!),
                          style: boldTextStyle(
                            size: 10,
                          ),
                        ),
                        10.height,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: white,
                              ),
                              5.width,
                              Text(
                                "Play",
                                style: boldTextStyle(
                                  size: 14,
                                  color: white,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ).visible(!inProgress);
            }
            return Loader();
          }),
      20.height.visible(!inProgress),
      Divider(),
    ],
  );
}
