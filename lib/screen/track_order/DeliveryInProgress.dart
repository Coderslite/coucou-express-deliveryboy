import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/screen/track_order/in_progress/ArrivedAtBuyFrom.dart';
import 'package:food_delivery/screen/track_order/in_progress/ArrivedAtCustomerLocation.dart';
import 'package:food_delivery/screen/track_order/in_progress/Delivered.dart';
import 'package:food_delivery/screen/track_order/in_progress/OrderAccepted.dart';
import 'package:food_delivery/screen/track_order/in_progress/PaidAndPickup.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/SelectOrderHeader.dart';
import '../../utils/Colors.dart';
import '../../utils/Constants.dart';

class DeliveryInProgress extends StatefulWidget {
  final OrderModel order;

  const DeliveryInProgress({super.key, required this.order});

  @override
  State<DeliveryInProgress> createState() => _DeliveryInProgressState();
}

class _DeliveryInProgressState extends State<DeliveryInProgress> {
  int index = 0;
  var pageController = PageController();
  List steps = [
    {
      "name": "Order Accepted",
      "screen": OrderAccepted(),
    },
    {
      "name": "Arrived At Buy From Place",
      "screen": ArrivedAtBuyFrom(),
    },
    {
      "name": "Paid & Picked Up",
      "screen": PaidAndPickup(),
    },
    {
      "name": "Arrived at Customer’s Location",
      "screen": ArrivedAtCustomerLocation(),
    },
    {
      "name": "Delivered",
      "screen": Delivered(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<OrderModel>(
          stream: orderServices.getOrderById(widget.order.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;
              int index = data.orderStatus == ORDER_ACCEPTED ||
                      data.orderStatus == ORDER_CONFIRMED
                  ? 0
                  : data.orderStatus == ORDER_BUYFROM
                      ? 1
                      : data.orderStatus == ORDER_PICKUP
                          ? 2
                          : data.orderStatus == ORDER_ARRIVED
                              ? 3
                              : data.orderStatus == ORDER_DELIVERED
                                  ? 4
                                  : 5;
              return SafeArea(
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
                            "Delivery In Process",
                            style: boldTextStyle(
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      10.height,
                      selectOrderHeader(context,
                          inProgress: true, order: widget.order),
                      10.height,
                      Text(
                        steps[index]['name'],
                        style: boldTextStyle(
                          size: 20,
                        ),
                      ),
                      10.height,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int x = 0; x < steps.length; x++)
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                      index > x
                                          ? "images/check.png"
                                          : "images/radio.png",
                                      fit: BoxFit.cover,
                                      color: x > index
                                          ? primaryColor.withOpacity(0.4)
                                          : null,
                                    ),
                                  ),
                                  5.width,
                                  Text(
                                    steps[x]['name'],
                                    overflow: TextOverflow.ellipsis,
                                    style: boldTextStyle(size: 14),
                                  ).visible(index == x),
                                ],
                              )
                          ],
                        ),
                      ),
                      20.height,
                      Divider(),
                      10.height,
                      Expanded(
                          child: PageView.builder(
                              controller: pageController,
                              onPageChanged: (value) {
                                index = value;
                                setState(() {});
                              },
                              itemCount: steps.length,
                              itemBuilder: (context, index) {
                                return steps[index]['screen'];
                              })),
                      AppButton(
                        onTap: () {
                          if (index < steps.length) {
                            pageController.nextPage(
                                duration: Duration(milliseconds: 100),
                                curve: Curves.ease);
                            handleUpdateStatus(index: index);
                          }
                        },
                        text: index + 1 == steps.length
                            ? "DONE"
                            : steps[index + 1]['name'],
                        textColor: white,
                        color: primaryColor,
                        width: double.infinity,
                      )
                    ],
                  ),
                ),
              );
            }
            return Loader();
          }),
    );
  }

  handleUpdateStatus({required int index}) async {
    var orderStatus = index == 0
        ? ORDER_BUYFROM
        : index == 1
            ? ORDER_PICKUP
            : index == 2
                ? ORDER_ARRIVED
                : index == 3
                    ? ORDER_DELIVERED
                    : ORDER_ACCEPTED;
    await orderServices.updateDocument(widget.order.id, {
      "orderStatus": orderStatus,
    });
  }
}
