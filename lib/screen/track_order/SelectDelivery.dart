import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/screen/track_order/DeliveryInProgress.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/SelectOrderHeader.dart';
import '../../components/StartDelivery.dart';
import '../../model/OrderModel.dart';
import '../../utils/Colors.dart';
import 'OrderAddItem.dart';
import 'SelectBuyFrom.dart';

class SelectDeliveryScreen extends StatefulWidget {
  final OrderModel order;
  final List<BuyFromModel> buyFromPlaces;
  final List<ItemModel> items;
  final String orderType;

  const SelectDeliveryScreen({
    super.key,
    required this.order,
    required this.buyFromPlaces,
    required this.items,
    required this.orderType,
  });

  @override
  State<SelectDeliveryScreen> createState() => _SelectDeliveryScreenState();
}

class _SelectDeliveryScreenState extends State<SelectDeliveryScreen> {
  String buyFrom = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    "Delivery Address",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    buyFromOption(value: 'Inside UCAD'),
                    buyFromOption(value: 'Around UCAD'),
                    buyFromOption(value: 'Outside UCAD'),
                    10.height,
                    Text(
                      "House / Apartment No.",
                      style: boldTextStyle(
                        size: 14,
                      ),
                    ),
                    10.height,
                    AppTextField(
                      textFieldType: TextFieldType.OTHER,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Loader().visible(isLoading),
              AppButton(
                onTap: () {
                  handleSaveUpdate();
                },
                width: double.infinity,
                color: primaryColor,
                text: "SAVE",
                textColor: white,
              ).visible(!isLoading)
            ],
          ),
        ),
      ),
    );
  }

  buyFromOption({required String value}) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: buyFrom,
          activeColor: primaryColor,
          onChanged: (v) {
            buyFrom = value;
            setState(() {});
          },
        ),
        Expanded(
            child: Text(
          value,
          style: primaryTextStyle(
            size: 14,
          ),
        ))
      ],
    ).onTap(() {
      buyFrom = value;

      setState(() {});
    });
  }

  handleSaveUpdate() async {
    isLoading = true;
    setState(() {});
    List items = [];
    for (var item in widget.items) {
      items.add({
        "itemName": item.itemName,
        "itemPrice": item.itemPrice!.toInt(),
        "qty": item.qty,
      });
    }

    List buyFromPlaces = [];
    for (var buyFrom in widget.buyFromPlaces) {
      buyFromPlaces.add({
        "locationType": buyFrom.locationType,
        "address": buyFrom.address,
      });
    }

    await orderServices.updateDocument(widget.order.id, {
      "listOfOrder": items,
      "orderStatus": ORDER_AWAIT_CUSTOMER,
      "buyFromPlaces": buyFromPlaces,
      "updatedOrderType": widget.orderType,
    });
    isLoading = false;
    setState(() {});
    handleStartDelivery(
        isConfirmed: false, context: context, order: widget.order);
  }
}
