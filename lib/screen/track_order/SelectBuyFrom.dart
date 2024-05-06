import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/screen/track_order/SelectDelivery.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/SelectOrderHeader.dart';
import '../../model/OrderModel.dart';
import 'OrderAddItem.dart';

class BuyFromModel {
  String locationType;
  String address;


  BuyFromModel({
    required this.locationType,
    required this.address,
  });
}

class SelectBuyFromScreen extends StatefulWidget {
  final OrderModel order;
  final List<ItemModel> items;
  final String orderType;


  const SelectBuyFromScreen(
      {super.key, required this.order, required this.items, required this.orderType});

  @override
  State<SelectBuyFromScreen> createState() => _SelectBuyFromScreenState();
}

class _SelectBuyFromScreenState extends State<SelectBuyFromScreen> {
  List<BuyFromModel> buyFromPlaces = [];
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
                  "Buy From / Pickup Place",
                  style: boldTextStyle(
                    size: 20,
                  ),
                )
              ],
            ),
            10.height,
            selectOrderHeader(context, inProgress: false, order: widget.order),
            20.height,
            Expanded(
              child: buyFromPlaces.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Select suggested buy from place",
                            style: boldTextStyle(
                              size: 14,
                            ),
                          ),
                        ),
                        10.height,
                        SizedBox(
                          height: 35,
                          child: Material(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            child: MaterialButton(
                              onPressed: () async {
                                var data = await showModalBottomSheet(
                                    barrierColor: black.withOpacity(0.5),
                                    isScrollControlled: true,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return AddressModal();
                                    });
                                handleAddBuyFrom(
                                    buyFrom: data['buyFrom'],
                                    address: data['address']);
                              },
                              child: Text(
                                "Add New Address",
                                style: primaryTextStyle(color: white, size: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: buyFromPlaces.length,
                      itemBuilder: (context, index) {
                        var eachBuyFrom = buyFromPlaces[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: primaryColor,
                                        radius: 10,
                                        child: Text(
                                          "${index + 1}",
                                          style: boldTextStyle(
                                            size: 12,
                                            color: white,
                                          ),
                                        ),
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              eachBuyFrom.address,
                                              style: boldTextStyle(size: 14),
                                            ),
                                            Text(
                                              eachBuyFrom.locationType,
                                              style: primaryTextStyle(size: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.width,
                                Icon(
                                  Icons.delete_outline,
                                  color: primaryColor,
                                  size: 25,
                                ).onTap(
                                  () {
                                    hanldeDeleteItem(index);
                                  },
                                ),
                              ],
                            ),
                            20.height,
                            SizedBox(
                              height: 35,
                              child: Material(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                child: MaterialButton(
                                  onPressed: () async {
                                    var data = await showModalBottomSheet(
                                        barrierColor: black.withOpacity(0.5),
                                        isScrollControlled: true,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return AddressModal();
                                        });
                                    handleAddBuyFrom(
                                        buyFrom: data['buyFrom'],
                                        address: data['address']);
                                  },
                                  child: Text(
                                    "Add New Address",
                                    style: primaryTextStyle(
                                        color: white, size: 14),
                                  ),
                                ),
                              ),
                            ).visible(index + 1 == buyFromPlaces.length),
                          ],
                        );
                      }),
            ),
            30.height,
            AppButton(
              onTap: () {
                SelectDeliveryScreen(
                  order: widget.order,
                  buyFromPlaces: buyFromPlaces,
                  items: widget.items,
                  orderType: widget.orderType,
                ).launch(context);
              },
              text: "Next",
              color: primaryColor,
              textColor: white,
              width: double.infinity,
            )
          ],
        ),
      )),
    );
  }

  handleAddBuyFrom({required String buyFrom, required String address}) {
    buyFromPlaces.add(BuyFromModel(locationType: buyFrom, address: address));
    address = "";
    buyFrom = '';
    setState(() {});
  }

  hanldeDeleteItem(int index) {
    buyFromPlaces.removeAt(index);
    setState(() {});
  }
}

class AddressModal extends StatefulWidget {
  AddressModal({
    super.key,
  });

  @override
  State<AddressModal> createState() => _AddressModalState();
}

class _AddressModalState extends State<AddressModal> {
  final _formKey = GlobalKey<FormState>();
  var buyFrom = '';
  var addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Wrap(
            spacing: 10,
            children: [
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Address",
                    style: boldTextStyle(
                      size: 20,
                    ),
                  ),
                  ClipOval(
                    child: Card(
                      color: context.scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                  ).onTap(() {
                    finish(context);
                  })
                ],
              ),
              20.height,
              Text(
                "Select buy from / pickup place",
                style: boldTextStyle(size: 16),
              ),
              10.height,
              buyFromOption(value: 'Inside UCAD'),
              buyFromOption(value: 'Around UCAD'),
              buyFromOption(value: 'Outside UCAD'),
              10.height,
              Text(
                "Address",
                style: boldTextStyle(size: 14),
              ),
              AppTextField(
                textFieldType: TextFieldType.OTHER,
                controller: addressController,
                validator: (val) {
                  if (val.isEmptyOrNull) {
                    return "This field is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder()),
              ),
              20.height,
              AppButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    finish(context, {
                      "buyFrom": buyFrom,
                      "address": addressController.text,
                    });
                  }
                },
                color: primaryColor,
                width: double.infinity,
                text: "DONE",
                textColor: white,
              ),
              20.height,
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
}
