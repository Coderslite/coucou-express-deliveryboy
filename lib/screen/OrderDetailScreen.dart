import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/UploadFileModal.dart';
import '../utils/Constants.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel? orderModel;

  OrderDetailScreen({this.orderModel});

  @override
  OrderDetailScreenState createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;

  @override
  void initState() {
    if (widget.orderModel!.orderStatus.validate() == ORDER_STATUS_PENDING) {
      currentStep = 0;
    } else if (widget.orderModel!.orderStatus.validate() ==
        ORDER_STATUS_RECEIVED) {
      currentStep = 1;
    } else if (widget.orderModel!.orderStatus.validate() ==
        ORDER_STATUS_PICKUP) {
      currentStep = 2;
    } else if (widget.orderModel!.orderStatus.validate() ==
        ORDER_STATUS_DELIVERING) {
      currentStep = 3;
    } else if (widget.orderModel!.orderStatus.validate() ==
        ORDER_STATUS_COMPLETE) {
      currentStep = 4;
    }
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
    return Scaffold(
      appBar: appBarWidget('#${widget.orderModel!.orderId}',
          color: context.cardColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            Stepper(
              currentStep: currentStep,
              physics: NeverScrollableScrollPhysics(),
              steps: [
                Step(
                  title: Text(ORDER_STATUS_PENDING),
                  subtitle: Text(currentStep == 0
                      ? "Current Order Status"
                      : currentStep > 0
                          ? "Completed"
                          : ""),
                  isActive: currentStep >= 0 ? true : false,
                  state: currentStep > 0
                      ? StepState.complete
                      : currentStep < 0
                          ? StepState.disabled
                          : StepState.editing,
                  content: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset("images/pending_order.png"),
                  ),
                ),
                Step(
                  title: Text(ORDER_STATUS_RECEIVED),
                  subtitle: Text(currentStep == 1
                      ? "Current Order Status"
                      : currentStep > 1
                          ? "Completed"
                          : ""),
                  isActive: currentStep >= 1 ? true : false,
                  state: currentStep > 1
                      ? StepState.complete
                      : currentStep < 1
                          ? StepState.disabled
                          : StepState.editing,
                  content: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset("images/received.jpg"),
                  ),
                ),
                Step(
                  title: Text(ORDER_STATUS_PICKUP),
                  subtitle: Text(currentStep == 2
                      ? "Current Order Status"
                      : currentStep > 2
                          ? "Completed"
                          : ""),
                  isActive: currentStep >= 2 ? true : false,
                  state: currentStep > 2
                      ? StepState.complete
                      : currentStep < 2
                          ? StepState.disabled
                          : StepState.editing,
                  content: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset("images/pickup.jpg"),
                  ),
                ),
                Step(
                  title: Text(ORDER_STATUS_DELIVERING),
                  subtitle: Text(currentStep == 3
                      ? "Current Order Status"
                      : currentStep > 3
                          ? "Completed"
                          : ""),
                  isActive: currentStep >= 3 ? true : false,
                  state: currentStep > 3
                      ? StepState.complete
                      : currentStep < 2
                          ? StepState.disabled
                          : StepState.editing,
                  content: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset("images/delivery_boy.png"),
                  ),
                ),
                Step(
                  title: Text(ORDER_STATUS_COMPLETE),
                  subtitle: Text(currentStep == 4
                      ? "Current Order Status"
                      : currentStep > 4
                          ? "Completed"
                          : ""),
                  isActive: currentStep >= 4 ? true : false,
                  state: currentStep > 4
                      ? StepState.complete
                      : currentStep < 4
                          ? StepState.disabled
                          : StepState.editing,
                  content: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset("images/delivered.jpg"),
                  ),
                ),
              ],
              controlsBuilder: (context, details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (currentStep <= 1) {
                        } else {
                          setState(() {
                            currentStep--;
                          });
                          orderServices.updateDocument(widget.orderModel!.id, {
                            OrderKey.orderStatus: currentStep == 1
                                ? ORDER_STATUS_RECEIVED
                                : currentStep == 2
                                    ? ORDER_STATUS_PICKUP
                                    : currentStep == 3
                                        ? ORDER_STATUS_DELIVERING
                                        : ORDER_STATUS_COMPLETE
                          });
                        }
                      },
                      child: Text("Previous Phase"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            currentStep <= 1 ? lightGray : colorPrimary,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (currentStep >= 4) {
                          showInDialog(
                            context,
                            builder: (p0) {
                              return UploadFile();
                            },
                          );
                        } else {
                          orderServices.updateDocument(widget.orderModel!.id, {
                            OrderKey.orderStatus: currentStep == 0
                                ? ORDER_STATUS_RECEIVED
                                : currentStep == 1
                                    ? ORDER_STATUS_PICKUP
                                    : currentStep == 2
                                        ? ORDER_STATUS_DELIVERING
                                        : ORDER_STATUS_COMPLETE
                          });
                          setState(() {
                            currentStep++;
                          });
                        }
                      },
                      child: Text(
                          currentStep >= 4 ? "Upload Receipt" : "Next Phase"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            currentStep >= 5 ? lightBlue : primaryColor,
                      ),
                    ),
                  ],
                );
              },
            ),
            32.height,
            Text(appStore.translate('order_id'), style: boldTextStyle()),
            8.height,
            Text('${widget.orderModel!.orderId!.validate()}',
                style: boldTextStyle(size: 12)),
            32.height,
            Text(appStore.translate('date'), style: boldTextStyle()),
            8.height,
            Text(
              '${appStore.translate('delivery_to')} ${DateFormat('EEE d, MMM yyyy HH:mm:ss').format(widget.orderModel!.createdAt!)}',
              style: boldTextStyle(size: 12),
            ),
            32.height,
            Text(appStore.translate('delivery_to'), style: boldTextStyle()),
            8.height,
            Text(widget.orderModel!.userAddress.validate(),
                style: boldTextStyle(size: 12)),
            16.height,
            Text(appStore.translate('delivery_charge'), style: boldTextStyle()),
            8.height,
            Text(
                widget.orderModel!.deliveryCharge
                    .validate()
                    .toCurrencyAmount()
                    .toString(),
                style: boldTextStyle()),
            Divider(thickness: 2),
            16.height,
            Text(appStore.translate('order_Items'), style: boldTextStyle())
                .paddingLeft(16),
            32.height,
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              itemCount: widget.orderModel!.orderItems!.length,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.scaffoldBackgroundColor,
                        boxShadow: defaultBoxShadow(
                            spreadRadius: 0.0, blurRadius: 0.0),
                        border: Border.all(color: context.dividerColor),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: commonCachedNetworkImage(
                        widget.orderModel!.orderItems![index].image!.validate(),
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(12),
                    ),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.orderModel!.orderItems![index].itemName
                              .validate(),
                          style: boldTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(appStore.translate('price'),
                                style: primaryTextStyle()),
                            8.width,
                            Text(
                                widget.orderModel!.orderItems![index].itemPrice
                                    .toCurrencyAmount()
                                    .validate()
                                    .toString(),
                                style: boldTextStyle()),
                          ],
                        ),
                        4.height,
                        RichTextWidget(list: [
                          TextSpan(
                              text: '${appStore.translate('restaurant')} :- ',
                              style: secondaryTextStyle()),
                          TextSpan(
                              text:
                                  widget.orderModel!.restaurantName.validate(),
                              style: secondaryTextStyle()),
                        ])
                      ],
                    ).expand(),
                    Text(
                        'x ${widget.orderModel!.orderItems![index].qty.validate().toString()}',
                        style: primaryTextStyle()),
                  ],
                ).paddingBottom(16);
              },
            ),
          ],
        ).paddingOnly(left: 16, right: 16),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 16),
        color: appStore.isDarkMode ? scaffoldColorDark : white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appStore.translate('total'),
                    style: primaryTextStyle(size: 18)),
                Text(
                    widget.orderModel!.totalAmount
                        .toCurrencyAmount()
                        .validate()
                        .toString(),
                    style: boldTextStyle(size: 22)),
              ],
            ).paddingOnly(left: 16, right: 16),
          ],
        ),
      ),
    );
  }
}
