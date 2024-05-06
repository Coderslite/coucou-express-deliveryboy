import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/screen/track_order/OrderAddItem.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/SelectOrderHeader.dart';
import '../../components/StartDelivery.dart';
import '../../utils/Constants.dart';

class SelectOrderScreen extends StatefulWidget {
  final OrderModel order;
  const SelectOrderScreen({super.key, required this.order});

  @override
  State<SelectOrderScreen> createState() => _SelectOrderScreenState();
}

class _SelectOrderScreenState extends State<SelectOrderScreen> {
  String orderType = '';

  @override
  void initState() {
    handleCheckStatus();
    super.initState();
  }

  handleCheckStatus() async {
    await Future.delayed(Duration(seconds: 1));
    if (widget.order.orderStatus == ORDER_CONFIRMED) {
      handleStartDelivery(
          order: widget.order, isConfirmed: true, context: context);
    } else if (widget.order.orderStatus == ORDER_AWAIT_CUSTOMER) {
      handleStartDelivery(
          order: widget.order, isConfirmed: false, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Card(
                    color: context.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                  ).onTap(() {
                    finish(context);
                  }),
                  10.width,
                  Text(
                    "Select Order Type",
                    style: boldTextStyle(
                      size: 20,
                    ),
                  )
                ],
              ),
              10.height,
              selectOrderHeader(context,
                  inProgress: false, order: widget.order),
              20.height,
              Expanded(
                  child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: orderType == 'Yonnima' ? 2 : 0.2,
                          color: orderType == 'Yonnima' ? primaryColor : grey,
                        )),
                    child: Row(
                      children: [
                        Text(
                          "Yonnima",
                          style: boldTextStyle(
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ).onTap(() {
                    if (orderType == 'Yonnima') {
                      orderType = '';
                      setState(() {});
                      return;
                    }
                    orderType = 'Yonnima';
                    setState(() {});
                  }),
                  20.height,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: orderType == 'Food Order' ? 2 : 0.2,
                          color:
                              orderType == 'Food Order' ? primaryColor : grey,
                        )),
                    child: Row(
                      children: [
                        Text(
                          "Food Order",
                          style: boldTextStyle(
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ).onTap(() {
                    if (orderType == 'Food Order') {
                      orderType = '';
                      setState(() {});
                      return;
                    }
                    orderType = 'Food Order';
                    setState(() {});
                  })
                ],
              )),
              AppButton(
                onTap: () {
                  OrderAddItemScreen(
                    order: widget.order,
                    orderType: orderType,
                  ).launch(context);
                },
                disabledColor: primaryColor.withOpacity(0.5),
                disabledTextColor: white.withOpacity(0.5),
                enabled: orderType.isNotEmpty,
                color: primaryColor,
                width: double.infinity,
                textColor: white,
                text: "Next",
              )
            ],
          ),
        ),
      ),
    );
  }
}
