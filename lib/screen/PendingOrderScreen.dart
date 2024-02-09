// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery/components/PendingOrderItemWidget.dart';
import 'package:food_delivery/functions/SendNotification.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../main.dart';
import 'OrderDetailScreen.dart';

class PendingOrderScreen extends StatefulWidget {
  static String tag = '/OrderScreen';

  @override
  PendingOrderScreenState createState() => PendingOrderScreenState();
}

class PendingOrderScreenState extends State<PendingOrderScreen> {
  Key uniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldColorDark : white,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appStore.setAppLocalization(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(appStore.translate('new_orders'), showBack: false),
        body: getBoolAsync(AVAILABLE) == true
            ? Column(
                children: [
                  Text(
                    "You are unavailable to accept an order, kind change your availability status",
                    style: boldTextStyle(color: orangeRed),
                  ).paddingAll(10).visible(getBoolAsync(AVAILABLE) == false ||
                      getBoolAsync(AVAILABLE).toString() == 'null'),
                  Expanded(
                    child: PaginateFirestore(
                      key: uniqueKey,
                      itemBuilder: (BuildContext context, items, index) {
                        var order = items[index].data() as Map<String, dynamic>;
                        // return order['orderStatus'] == NO_DRIVER_AVAILABLE
                        return PendingOrderItemWidget(
                          index: index,
                          orderData: OrderModel.fromJson(order),
                          onAccept: () {
                            setState(() {
                              db
                                  .collection("users")
                                  .where('uid', isEqualTo: order['userId'])
                                  .get()
                                  .then((value) {
                                var token = value.docs.first
                                    .data()[UserKey.oneSignalPlayerId];
                                print(token);
                                List tokens = [];
                                tokens.add(token);
                                sendNotification(
                                    tokens,
                                    "Order Accepted",
                                    "Your Order has been received, a delivery agent has been asigned",
                                    order[OrderKey.orderId]);
                                userService.updateDocument(
                                  getStringAsync(USER_ID),
                                  {
                                    "availabilityStatus": false,
                                  },
                                );
                                setBoolAsync(AVAILABLE, false);
                                orderServices.updateDocument(items[index].id, {
                                  OrderKey.deliveryBoyId:
                                      getStringAsync(USER_ID),
                                  "taken": true,
                                  'orderStatus': ORDER_ACCEPTED,
                                });
                                OrderDetailScreen(
                                  orderModel: OrderModel.fromJson(order),
                                ).launch(context);
                              });
                            });
                          },
                        );
                      },
                      itemBuilderType: PaginateBuilderType.listView,
                      query: orderServices.pendingOrderQuery(),
                      isLive: true,
                      physics: ClampingScrollPhysics(),
                      // shrinkWrap: true,
                      itemsPerPage: DocLimit,
                      bottomLoader: Loader(),
                      initialLoader: Loader(),
                      onEmpty: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          commonCachedNetworkImage('images/Empty.png',
                              height: 150, width: 150, fit: BoxFit.cover),
                          16.height,
                          Text(appStore.translate('order_not_found'),
                              style: boldTextStyle()),
                        ],
                      ).center(),
                      onError: (e) =>
                          Text(e.toString(), style: primaryTextStyle())
                              .center(),
                    ),
                  ),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/Not_available.png',
                          width: 150,
                          height: 150,
                        ).center(),
                        32.height,
                        Text(appStore.translate('your_status_is_not_available'),
                            style: primaryTextStyle(),
                            textAlign: TextAlign.center),
                        16.height,
                        AppButton(
                          text: appStore.translate('set_to_Available'),
                          textStyle: boldTextStyle(),
                          onTap: () async {
                            showConfirmDialog(
                                    context,
                                    appStore.translate(
                                        'are_you_sure_change_want_your_status'),
                                    positiveText: appStore.translate('yes'),
                                    negativeText: appStore.translate('no'))
                                .then((value) async {
                              if (value ?? false) {
                                appStore.setLoading(true);
                                await userService.updateDocument(
                                    getStringAsync(USER_ID), {
                                  UserKey.availabilityStatus: true
                                }).then((value) async {
                                  await setValue(AVAILABLE, true);
                                  setState(() {});
                                }).catchError((error) {
                                  toast(error.toString());
                                });
                              }
                              appStore.setLoading(false);
                            });
                          },
                        ).center(),
                      ],
                    ),
                  ),
                  Observer(
                      builder: (_) => Loader().visible(appStore.isLoading)),
                ],
              ).center(),
      ),
    );
  }
}
