import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/screen/track_order/SelectBuyFrom.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/SelectOrderHeader.dart';
import '../../model/OrderModel.dart';

class ItemModel {
  String itemName;
  int qty;
  double? itemPrice;
  ItemModel({
    required this.itemName,
    required this.qty,
    this.itemPrice,
  });
}

class OrderAddItemScreen extends StatefulWidget {
  final OrderModel order;
  final String orderType;

  const OrderAddItemScreen(
      {super.key, required this.order, required this.orderType});

  @override
  State<OrderAddItemScreen> createState() => _OrderAddItemScreenState();
}

class _OrderAddItemScreenState extends State<OrderAddItemScreen> {
  List<ItemModel> items = [];
  var nameController = TextEditingController();
  var qtyController = TextEditingController();
  var priceController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
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
                    "Items",
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
                  child: items.isEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 35,
                              child: Material(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                child: MaterialButton(
                                  onPressed: () {
                                    handleAddItem();
                                  },
                                  child: Text(
                                    "Add New Item",
                                    style: primaryTextStyle(
                                        color: white, size: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            var item = items[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: context.cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        child: Text(
                                          item.itemName,
                                          style: boldTextStyle(
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${getAmount(item.itemPrice.validate().toInt())}",
                                        style: boldTextStyle(
                                          size: 14,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color:
                                                primaryColor.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.remove,
                                              size: 12,
                                            ).onTap(() {
                                              handleSubtraction(index);
                                            }),
                                            5.width,
                                            Text(
                                              "${item.qty.validate()}",
                                              style: primaryTextStyle(size: 14),
                                            ),
                                            5.width,
                                            Icon(
                                              Icons.add,
                                              size: 12,
                                            ).onTap(() {
                                              handleAddition(index);
                                            }),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Image.asset(
                                              "images/edit.png",
                                              fit: BoxFit.cover,
                                              color: primaryColor,
                                            ),
                                          ).onTap(() {
                                            handleUpdateItem(index);
                                          }),
                                          5.width,
                                          Icon(
                                            Icons.delete_outline,
                                            color: primaryColor,
                                            size: 25,
                                          ).onTap(() {
                                            hanldeDeleteItem(index);
                                          })
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                10.height,
                                SizedBox(
                                  height: 35,
                                  child: Material(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    child: MaterialButton(
                                      onPressed: () {
                                        handleAddItem();
                                      },
                                      child: Text(
                                        "Add New Item",
                                        style: primaryTextStyle(
                                            color: white, size: 14),
                                      ),
                                    ),
                                  ),
                                ).visible((index + 1) == items.length)
                              ],
                            );
                          })),
              AppButton(
                onTap: () {
                  SelectBuyFromScreen(
                    order: widget.order,
                    items: items,
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
        ),
      ),
    );
  }

  handleAddItem() {
    nameController.clear();
    priceController.clear();
    qtyController.clear();
    showModalBottomSheet(
        barrierColor: black.withOpacity(0.5),
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    20.height,
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Divider(
                        height: 2,
                        thickness: 5,
                        color: context.iconColor.withOpacity(0.4),
                      ),
                    ).center(),
                    20.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Item",
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
                    AppTextField(
                      textFieldType: TextFieldType.OTHER,
                      validator: (val) {
                        if (val.isEmptyOrNull) {
                          return "Item Name is required";
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        label: Text(
                          "Item Name",
                          style: secondaryTextStyle(color: primaryColor),
                        ),
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
                    20.height,
                    AppTextField(
                      textFieldType: TextFieldType.OTHER,
                      controller: qtyController,
                      validator: (val) {
                        if (val.isEmptyOrNull) {
                          return "Item Quantity is required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        label: Text(
                          "Quantiy",
                          style: secondaryTextStyle(color: primaryColor),
                        ),
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
                    20.height,
                    AppTextField(
                      textFieldType: TextFieldType.OTHER,
                      controller: priceController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        label: Text(
                          "Price (optional)",
                          style: secondaryTextStyle(color: primaryColor),
                        ),
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
                    20.height,
                    AppButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          items.add(
                            ItemModel(
                                itemName: nameController.text,
                                qty: int.tryParse(qtyController.text)!,
                                itemPrice:
                                    double.tryParse(priceController.text)),
                          );
                          nameController.clear();
                          priceController.clear();
                          qtyController.clear();
                          setState(() {});
                        }
                      },
                      text: "Add Item",
                      textColor: white,
                      color: primaryColor,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  handleAddition(int index) {
    items[index].qty++;
    setState(() {});
  }

  handleSubtraction(int index) {
    items[index].qty--;
    setState(() {});
  }

  hanldeDeleteItem(int index) {
    items.removeAt(index);
    setState(() {});
  }

  handleUpdateItem(int index) {
    nameController.text = items[index].itemName;
    qtyController.text = items[index].qty.toString();
    priceController.text = items[index].itemPrice.toString();
    showModalBottomSheet(
        barrierColor: black.withOpacity(0.5),
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    20.height,
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Divider(
                        height: 2,
                        thickness: 5,
                        color: context.iconColor.withOpacity(0.4),
                      ),
                    ).center(),
                    20.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Update Item",
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
                    AppTextField(
                      textFieldType: TextFieldType.OTHER,
                      validator: (val) {
                        if (val.isEmptyOrNull) {
                          return "Item Name is required";
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        label: Text(
                          "Item Name",
                          style: secondaryTextStyle(color: primaryColor),
                        ),
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
                    20.height,
                    AppTextField(
                      textFieldType: TextFieldType.OTHER,
                      controller: qtyController,
                      validator: (val) {
                        if (val.isEmptyOrNull) {
                          return "Item Quantity is required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        label: Text(
                          "Quantiy",
                          style: secondaryTextStyle(color: primaryColor),
                        ),
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
                    20.height,
                    AppTextField(
                      textFieldType: TextFieldType.OTHER,
                      controller: priceController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        label: Text(
                          "Price (optional)",
                          style: secondaryTextStyle(color: primaryColor),
                        ),
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
                    20.height,
                    AppButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          items[index] = ItemModel(
                            itemName: nameController.text,
                            qty: int.tryParse(qtyController.text)!,
                            itemPrice: double.tryParse(priceController.text),
                          );
                          nameController.clear();
                          priceController.clear();
                          qtyController.clear();
                          setState(() {});
                        }
                      },
                      text: "Update Item",
                      textColor: white,
                      color: primaryColor,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
