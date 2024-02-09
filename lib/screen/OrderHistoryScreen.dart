import 'package:flutter/material.dart';
import 'package:food_delivery/components/OrderHistoryItemWidget.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../main.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  OrderHistoryScreenState createState() => OrderHistoryScreenState();
}

class OrderHistoryScreenState extends State<OrderHistoryScreen> {
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
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            appBarWidget(appStore.translate('order_history'), showBack: false),
        body: PaginateFirestore(
          itemBuilderType: PaginateBuilderType.listView,
          itemBuilder: (context, documentSnapshot, index) {
            return OrderHistoryItemWidget(OrderModel.fromJson(
                documentSnapshot[index].data() as Map<String, dynamic>));
          },
          query: orderServices.orderQuery(
            orderStatus: [
              ORDER_ACCEPTED,
              ORDER_PICKUP,
              ORDER_DELIVERED,
            ],
            // city: appStore.userCurrentCity,
            deliveryBoyId: getStringAsync(USER_ID),
            taken: true,
          ),
          isLive: true,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(8),
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
              Text(e.toString(), style: primaryTextStyle()).center(),
        ),
      ),
    );
  }
}
