import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/functions/SendNotification.dart';
import 'package:food_delivery/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../model/OrderModel.dart';
import '../services/CalculateDistance.dart';
import '../services/GeoLocationLatLng.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';

class NotePad extends StatefulWidget {
  final OrderModel orderData;
  final String token;
  const NotePad({super.key, required this.orderData, required this.token});

  @override
  State<NotePad> createState() => _NotePadState();
}

class _NotePadState extends State<NotePad> {
  final TextEditingController otherController = TextEditingController();
  var qty = TextEditingController();
  var itemName = TextEditingController();
  var suggestedPrice = TextEditingController();
  bool accepted = false;
  bool isLoading = true;
  String restaurantName = '';
  String city = '';
  List<OrderItems> items = [];
  var deliveryFee = 0;
  var totalQty = 0;
  var totalAround = 0;

  var _formKey = GlobalKey<FormState>();

  bool isPlaying = false;
  bool isPaused = true;
  Duration totalDuration = Duration();
  Duration currentPosition = Duration();

  AudioPlayer audioPlayer = AudioPlayer();

  void playAudio(String audioUrl) async {
    await audioPlayer.play(UrlSource('$audioUrl')).then((value) async {
      trackProgress();
    });
  }

  void trackProgress() async {
    await audioPlayer.getDuration().then((value) {
      setState(() {
        totalDuration = value!;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        currentPosition = position;
        print("current Position" + currentPosition.toString());
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        isPaused = true;
        currentPosition = Duration();
        totalDuration = Duration();
      });
    });
    setState(() {
      isPlaying = true;
      isPaused = false;
    });
  }

  void pauseAudio() async {
    await audioPlayer.pause().then((value) {
      setState(() {
        print("paused");
        isPaused = true;
      });
    });
  }

  void resumeAudio() async {
    await audioPlayer.resume().then((value) {
      setState(() {
        print("resuming");
        isPlaying = true;
        isPaused = false;
      });
    });
  }

  @override
  void initState() {
    items = widget.orderData.orderItems!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Update Order Item',
        color: context.cardColor,
        actions: [
          widget.orderData.orderType != 'VoiceOrder'
              ? Container()
              : ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: mediumSeaGreen),
                  onPressed: () {
                    showInDialog(context,
                        title: Text(
                          "Add Item",
                          style: primaryTextStyle(),
                        ),
                        actions: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: redColor),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Close")),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: mediumSeaGreen),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  var item = OrderItems(
                                      itemName: itemName.text,
                                      qty: int.parse(qty.text),
                                      itemPrice:
                                          int.tryParse(suggestedPrice.text));
                                  handleAddToList(item);
                                }
                              },
                              child: Text("Add")),
                        ],
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppTextField(
                                controller: itemName,
                                textFieldType: TextFieldType.NAME,
                                decoration: InputDecoration(
                                  label: Text("Item Name *"),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field Required";
                                  }
                                  return null;
                                },
                              ),
                              AppTextField(
                                controller: qty,
                                textFieldType: TextFieldType.NUMBER,
                                decoration: InputDecoration(
                                  label: Text("Quantity *"),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field Required";
                                  }
                                  return null;
                                },
                              ),
                              AppTextField(
                                controller: suggestedPrice,
                                textFieldType: TextFieldType.NUMBER,
                                isValidationRequired: false,
                                decoration: InputDecoration(
                                  label: Text(
                                    "Suggested price per quantity",
                                    style: primaryTextStyle(wordSpacing: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                  child: Text(
                    "Add More",
                    style: primaryTextStyle(),
                  ),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            widget.orderData.orderType == 'VoiceOrder'
                ? Row(
                    children: [
                      InkWell(
                        onTap: () {
                          totalDuration == Duration()
                              ? playAudio(widget.orderData.orderUrl.toString())
                              : isPaused
                                  ? resumeAudio()
                                  : pauseAudio();
                        },
                        child: CircleAvatar(
                          child: Icon(
                            isPaused ? Icons.play_arrow : Icons.pause,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      !isPlaying
                          ? Container()
                          : Expanded(
                              child: ProgressBar(
                                timeLabelTextStyle: primaryTextStyle(),
                                progress: currentPosition,
                                // buffered: Duration(milliseconds: 2000),
                                total: totalDuration,
                                onSeek: (duration) {
                                  audioPlayer.seek(duration);
                                },
                              ),
                            ),
                    ],
                  )
                : Container(),
            10.height,
            Text("Please add/update order items",
                style: boldTextStyle(size: 18)),
            4.height,
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        "No Item Added Yet",
                        style: primaryTextStyle(),
                      ),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var yonnima = items[index];
                        return Card(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${yonnima.itemName} * ${yonnima.qty}",
                                  style: primaryTextStyle(size: 20),
                                ),
                                InkWell(
                                  onTap: () {
                                    itemName.text = yonnima.itemName!;
                                    qty.text = "${yonnima.qty}";
                                    if (yonnima.itemPrice == null) {
                                      suggestedPrice.clear();
                                    } else {
                                      suggestedPrice.text =
                                          yonnima.itemPrice.toString();
                                    }
                                    showInDialog(context,
                                        title: Text(
                                          "Update Item",
                                          style: primaryTextStyle(),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: redColor),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Close")),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      mediumSeaGreen),
                                              onPressed: () {
                                                var item = OrderItems(
                                                  itemName: itemName.text,
                                                  qty: int.parse(qty.text),
                                                  itemPrice: int.tryParse(
                                                      suggestedPrice.text),
                                                );
                                                handleUpdateItem(item, index);
                                              },
                                              child: Text("Update Item")),
                                        ],
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppTextField(
                                              controller: itemName,
                                              textFieldType: TextFieldType.NAME,
                                              decoration: InputDecoration(
                                                label: Text("Item Name"),
                                              ),
                                            ),
                                            AppTextField(
                                              enabled:
                                                  widget.orderData.orderType ==
                                                      'VoiceOrder',
                                              controller: qty,
                                              textFieldType:
                                                  TextFieldType.NUMBER,
                                              decoration: InputDecoration(
                                                label: Text("Quantity"),
                                              ),
                                            ),
                                            AppTextField(
                                              controller: suggestedPrice,
                                              textFieldType:
                                                  TextFieldType.NUMBER,
                                              decoration: InputDecoration(
                                                label: Text(
                                                    "Item price per quantity"),
                                              ),
                                            ),
                                          ],
                                        ));
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: mediumSeaGreen,
                                  ),
                                )
                              ],
                            ),
                            subtitle: Text(
                              yonnima.itemPrice != null &&
                                      yonnima.itemPrice! > 0
                                  ? "${getAmount(yonnima.itemPrice! * yonnima.qty!)}"
                                  : 'price not available',
                              style: secondaryTextStyle(size: 14),
                            ),
                            leading: Text(
                              (index + 1).toString(),
                              style: primaryTextStyle(),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                setState(() {
                                  items.removeAt(index);
                                });
                              },
                              child: Icon(
                                Icons.delete,
                                color: redColor,
                              ),
                            ),
                          ),
                        );
                      }),
            ),
            4.height,
            items.isEmpty
                ? Container()
                : Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: mediumSeaGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.99,
                        height: 50,
                        child: Text(
                          "Add Item(s) to this Order",
                          style: primaryTextStyle(),
                        ).center()),
                  ).onTap(() {
                    addToCart();
                    Navigator.pop(context);
                  }),
          ],
        ),
      ),
    );
  }

  addToCart() async {
    var amount = 0;
    for (var i in items) {
      amount += i.itemPrice != null ? i.itemPrice! * i.qty! : 0;
    }
    var charge = widget.orderData.orderType == 'VoiceOrder'
        ? calculateDeliveryFee(items)
        : widget.orderData.deliveryCharge;
    await orderServices.updateDocument(widget.orderData.id, {
      "listOfOrder": items
          .map((item) => {
                "itemPrice": item.itemPrice,
                "itemName": item.itemName,
                "isSuggestedPrice": false,
                "qty": item.qty,
                "categoryId": item.categoryId,
                "categoryName": item.categoryName,
                "id": item.id,
                "image": item.image,
                "restaurantName": item.restaurantName,
                "restaurantAddress": item.restaurantAddress,
                "restaurantLocation": item.restaurantLocation,
                "restaurantId": item.restaurantId,
              })
          .toList(),
      "totalAmount": amount,
      "deliveryCharge": charge
    });

    print(widget.orderData.id);
    print(items[0].itemPrice);
    sendNotification(
        [widget.token],
        "Order Update Notice",
        "Please kindly note that your order have been updated",
        widget.orderData.id!);
    toast("Items added to Order");
  }

  handleAddToList(OrderItems item) async {
    items.add(item);
    setState(() {
      itemName.clear();
      qty.clear();
      suggestedPrice.clear();
    });
  }

  handleUpdateItem(OrderItems item, int index) async {
    items[index].itemName = item.itemName;
    items[index].qty = item.qty;
    items[index].itemPrice = item.itemPrice;
    setState(() {
      itemName.clear();
      qty.clear();
      suggestedPrice.clear();
    });
    Navigator.pop(context);
  }

  int calculateDeliveryFee(List<OrderItems> orderItems) {
    deliveryFee = 0;
    orderItems.forEach((element) async {
      if (widget.orderData.deliveryLocation == "Inside UCAD" &&
          element.restaurantLocation == 'Inside UCAD') {
        totalQty += element.qty!;
      } else if (widget.orderData.deliveryLocation == "Inside UCAD" &&
          element.restaurantLocation == 'Around UCAD') {
        totalAround += element.qty!;
      } else {
        if (widget.orderData.deliveryAddresss!.isNotEmpty) {
          LatLng userLocation = await getLatLngFromLocationName(
              widget.orderData.deliveryAddresss!);
          double roundedValue = double.parse(
              calculateDistance(UCAD_LOCATION, userLocation)
                  .toStringAsFixed(2));
          var charge = roundedValue * appStore.kmDeliveryCharge;
          deliveryFee = deliveryFee + charge.toInt();
          print("distance is $roundedValue");
        } else {
          print("restaurant name is empty");
        }
      }
    });
    if (totalQty <= 4 && totalQty > 0) {
      deliveryFee += 100;
    } else if (totalQty > 4 && totalQty < 25) {
      deliveryFee += totalQty * 25;
    } else if (totalQty > 25) {
      deliveryFee += 500;
    }
    if (totalAround > 0) {
      deliveryFee += appStore.constantDeliveryCharge.toInt();
    }
    return deliveryFee;
  }
}
