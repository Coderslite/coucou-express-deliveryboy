import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/components/DeliveryIncomeWidget.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class DeliveryIncomeScreen extends StatefulWidget {
  @override
  DeliveryIncomeScreenState createState() => DeliveryIncomeScreenState();
}

class DeliveryIncomeScreenState extends State<DeliveryIncomeScreen> {
  int? total = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    orderServices.deliveryOrderCharges().listen((event) {
      event.forEach((element) {
        element.deliveryCharge != null
            ? total = total.validate() + element.deliveryCharge!.validate()
            : SizedBox();
      });
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(appStore.translate('my_Income')),
      body: Stack(
        children: [
          FirestorePagination(
            itemBuilder: (context, documentSnapshot, index) {
              OrderModel orderData = OrderModel.fromJson(
                  documentSnapshot[index].data() as Map<String, dynamic>);
              return DeliveryIncomeWidget(orderData: orderData);
            },
            query: orderServices.orderQuery1(),
            isLive: true,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
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
          ).paddingOnly(top: 60),
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationRoundedWithShadow(12,
                backgroundColor: primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appStore.translate('total_Income'),
                    style: primaryTextStyle(color: white)),
                Text(getAmount(total!),
                        style: boldTextStyle(color: white),
                        textAlign: TextAlign.end)
                    .expand()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
