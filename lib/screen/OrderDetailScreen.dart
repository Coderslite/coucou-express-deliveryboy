import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/NotePad.dart';
import '../components/UploadFileModal.dart';
import '../functions/SendNotification.dart';
import '../utils/Constants.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel? orderModel;

  OrderDetailScreen({this.orderModel});

  @override
  OrderDetailScreenState createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  List tokens = [];

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
    super.initState();
    init();
  }

  handleCheckOrderStatus(String status) {
    if (status == ORDER_ACCEPTED) {
      currentStep = 0;
    } else if (status == ORDER_PICKUP) {
      currentStep = 1;
    } else if (status == ORDER_DELIVERED) {
      currentStep = 2;
    }
  }

  Future<void> completeDelivery(List token) async {
    /// Update document
    orderServices.updateDocument(widget.orderModel!.id, {
      OrderKey.orderStatus: ORDER_DELIVERED,
      OrderKey.paymentStatus: ORDER_PAYMENT_RECEIVED,
      CommonKey.updatedAt: DateTime.now(),
    }).then((value) {
      // ignore: deprecated_member_use
      setBoolAsync(AVAILABLE, true);
      userService.updateDocument(
        getStringAsync(USER_ID),
        {"availabilityStatus": true},
      );
      if (token.isNotEmpty) {
        sendNotification(token, 'Order Update', 'Your order is delivered',
            widget.orderModel!.id.toString());
      }
      toast("This order has been completed");
      finish(context);
    }).catchError((error) {
      toast(error.toString());
    });
  }

  Future<void> init() async {
    //
    db
        .collection("users")
        .where('uid', isEqualTo: widget.orderModel!.userId)
        .get()
        .then((value) {
      var token = value.docs.first.data()[UserKey.oneSignalPlayerId];
      print(token);
      setState(() {
        tokens.add(token);
      });
    });
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .doc(widget.orderModel!.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong"),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data!.data();
              handleCheckOrderStatus(data!['orderStatus']);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    currentStep >= 4
                        ? Container()
                        : widget.orderModel!.restaurantId != null &&
                                widget.orderModel!.restaurantId != ''
                            ? Container()
                            : FutureBuilder(
                                future: userService.getUserById(
                                    userId: widget.orderModel!.userId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Something went wrong");
                                  } else if (snapshot.hasData) {
                                    var token =
                                        snapshot.data!.oneSignalPlayerId;
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        NotePad(
                                          token: token!,
                                          orderData: widget.orderModel!,
                                        ).launch(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Update Order Items",
                                            style: boldTextStyle(),
                                          ),
                                          Icon(
                                            Icons.edit,
                                            color: primaryColor,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Text("");
                                  }
                                }),
                    Divider(),
                    10.height,
                    Stepper(
                      currentStep: currentStep,
                      physics: NeverScrollableScrollPhysics(),
                      steps: [
                        Step(
                          title: Text(
                            ORDER_ACCEPTED,
                            style: primaryTextStyle(),
                          ),
                          subtitle: Text(
                            currentStep == 0
                                ? "Current Order Status"
                                : currentStep > 0
                                    ? "Completed"
                                    : "",
                            style: primaryTextStyle(size: 12),
                          ),
                          isActive: currentStep >= 0 ? true : false,
                          state: currentStep > 0
                              ? StepState.complete
                              : currentStep < 0
                                  ? StepState.disabled
                                  : StepState.editing,
                          content: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: Image.asset("images/delivery_boy.png"),
                              ),
                            ],
                          ),
                        ),
                        Step(
                          title: Text(
                            ORDER_PICKUP,
                            style: primaryTextStyle(),
                          ),
                          subtitle: Text(
                            currentStep == 1
                                ? "Current Order Status"
                                : currentStep > 1
                                    ? "Completed"
                                    : "",
                            style: primaryTextStyle(size: 12),
                          ),
                          isActive: currentStep >= 1 ? true : false,
                          state: currentStep > 1
                              ? StepState.complete
                              : currentStep < 1
                                  ? StepState.disabled
                                  : StepState.editing,
                          content: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: Image.asset("images/pickup.jpg"),
                              ),
                              data['receiptUrl'] != null
                                  ? Container()
                                  : Column(
                                      children: [
                                        CircleAvatar(
                                          child: IconButton(
                                              onPressed: () {
                                                data['receiptUrl'] != null
                                                    ? print("all done")
                                                    : showInDialog(
                                                        context,
                                                        builder: (p0) {
                                                          return UploadFile(
                                                            orderModel: widget
                                                                .orderModel!,
                                                            tokens: tokens,
                                                          );
                                                        },
                                                      );
                                              },
                                              icon: Icon(Icons.upload_file)),
                                        ),
                                        Text(
                                          "Upload Item Receipt",
                                          style: primaryTextStyle(),
                                        )
                                      ],
                                    ),
                              20.height,
                            ],
                          ),
                        ),
                        Step(
                          title: Text(
                            ORDER_DELIVERED,
                            style: primaryTextStyle(),
                          ),
                          subtitle: Text(
                            currentStep == 2
                                ? "Current Order Status"
                                : currentStep > 2
                                    ? "Complete"
                                    : "",
                            style: primaryTextStyle(size: 12),
                          ),
                          isActive: currentStep >= 2 ? true : false,
                          state: currentStep > 2
                              ? StepState.complete
                              : currentStep < 2
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
                            data['receiptUrl'] != null
                                ? Container()
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        currentStep <= 1
                                            ? null
                                            : showInDialog(
                                                context,
                                                builder: (p0) {
                                                  return UploadFile(
                                                    orderModel:
                                                        widget.orderModel!,
                                                    tokens: tokens,
                                                  );
                                                },
                                              );
                                      },
                                      child: Text(
                                        "Upload Receipt",
                                        style: primaryTextStyle(
                                            color: currentStep <= 1
                                                ? grey
                                                : whiteSmoke),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: currentStep <= 1
                                            ? lightGray
                                            : colorPrimary,
                                      ),
                                    ),
                                  ),
                            currentStep >= 2
                                ? Container()
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (currentStep >= 1) {
                                          completeDelivery(tokens);
                                        } else {
                                          orderServices.updateDocument(
                                              widget.orderModel!.id, {
                                            OrderKey.orderStatus:
                                                currentStep == 0
                                                    ? ORDER_PICKUP
                                                    : ORDER_DELIVERED,
                                          });

                                          sendNotification(
                                              tokens,
                                              currentStep == 0
                                                  ? ORDER_PICKUP
                                                  : ORDER_DELIVERED,
                                              currentStep == 0
                                                  ? 'Order has been picked up'
                                                  : 'Order completed',
                                              widget.orderModel!.orderId!);
                                          setState(() {
                                            currentStep++;
                                          });
                                        }
                                      },
                                      child: Text(
                                        currentStep >= 2
                                            ? "Completed"
                                            : "Next Phase",
                                        style: primaryTextStyle(),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: currentStep >= 5
                                            ? lightBlue
                                            : primaryColor,
                                      ),
                                    ),
                                  ),
                          ],
                        );
                      },
                    ),
                    32.height,
                    Text(appStore.translate('order_id'),
                        style: boldTextStyle(color: primaryColor)),
                    8.height,
                    Text("#" '${widget.orderModel!.orderId!.validate()}',
                        style: boldTextStyle(size: 18)),
                    32.height,
                    Text(appStore.translate('date'),
                        style: boldTextStyle(color: primaryColor)),
                    8.height,
                    Text(
                      '${DateFormat('EEE d, MMM yyyy HH:mm:ss').format(widget.orderModel!.createdAt!)}',
                      style: boldTextStyle(size: 18),
                    ),
                    32.height,
                    Text(appStore.translate('delivery_to'),
                        style: boldTextStyle(color: primaryColor)),
                    8.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.orderModel!.deliveryLocation! ==
                                    'Inside UCAD'
                                ? widget.orderModel!.pavilionNo!
                                : widget.orderModel!.deliveryAddresss!,
                            style: boldTextStyle(size: 18)),
                        Text(
                          "Address is " + widget.orderModel!.deliveryLocation!,
                          style:
                              primaryTextStyle(color: primaryColor, size: 14),
                        ),
                        Divider(thickness: 2),
                        16.height,
                        Text(
                          "Payment Information",
                          style: boldTextStyle(size: 20),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment Method: ",
                              style: primaryTextStyle(size: 14),
                            ),
                            Row(
                              children: [
                                commonCachedNetworkImage(
                                  widget.orderModel!.paymentMethod == 'CASH'
                                      ? 'images/cash.png'
                                      : widget.orderModel!.paymentMethod ==
                                              'WAVE'
                                          ? 'images/wave.png'
                                          : 'images/orange.png',
                                  width: 50,
                                  height: 50,
                                ).visible(widget
                                    .orderModel!.paymentMethod!.isNotEmpty),
                                10.width,
                                Text(
                                  widget.orderModel!.paymentMethod.validate(),
                                  style: boldTextStyle(size: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        10.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment Status: ",
                              style: primaryTextStyle(size: 14),
                            ),
                            Text(
                              data['paymentStatus'].toString(),
                              style: boldTextStyle(
                                  size: 18,
                                  color: data['paymentStatus'] == 'Received'
                                      ? mediumSeaGreen
                                      : context.iconColor),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.check),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mediumSeaGreen),
                          onPressed: () async {
                            await orderServices.updateDocument(
                              widget.orderModel!.id,
                              {
                                "paymentStatus": "Received",
                              },
                            );
                            sendNotification(
                                tokens,
                                "Payment Update",
                                "Your payment has been received",
                                widget.orderModel!.id!);
                            setState(() {});
                          },
                          label: Text(
                            "Mark Paid",
                            style: primaryTextStyle(color: white),
                          ),
                        ).visible(data['paymentStatus'] != 'Received'),
                      ],
                    ),
                    16.height,
                    Divider(thickness: 2),
                    16.height,
                    Text(appStore.translate('order_Items'),
                            style: boldTextStyle())
                        .paddingLeft(16),
                    32.height,
                    widget.orderModel!.orderType == 'VoiceOrder'
                        ? Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  totalDuration == Duration()
                                      ? playAudio(widget.orderModel!.orderUrl
                                          .toString())
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      itemCount: widget.orderModel!.orderItems!.length,
                      itemBuilder: (context, index) {
                        var item = widget.orderModel!.orderItems![index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                backgroundColor:
                                    context.scaffoldBackgroundColor,
                                boxShadow: defaultBoxShadow(
                                    spreadRadius: 0.0, blurRadius: 0.0),
                                border: Border.all(color: context.dividerColor),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: commonCachedNetworkImage(
                                item.image == null
                                    ? img
                                    : item.image!.validate(),
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
                                  item.itemName.validate(),
                                  style: boldTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Text(
                                        item.itemPrice == null ||
                                                item.itemPrice == 0
                                            ? 'Price Not Available'
                                            : getAmount(item.itemPrice!)
                                                .toString(),
                                        style: boldTextStyle()),
                                  ],
                                ),
                                4.height,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.restaurantName.toString(),
                                      style: boldTextStyle(),
                                    ),
                                    Text(
                                      "(${item.restaurantLocation.toString()})",
                                      style: primaryTextStyle(
                                        color: mediumSeaGreen,
                                        size: 10,
                                      ),
                                    ),
                                  ],
                                ).visible(item.restaurantName == null &&
                                    item.restaurantName != ''),
                                Text(
                                  item.restaurantAddress.toString(),
                                  style: primaryTextStyle(size: 12),
                                ).visible(
                                    item.restaurantLocation == 'Around UCAD')
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
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 16),
        color: appStore.isDarkMode ? scaffoldColorDark : white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery Fee", style: primaryTextStyle(size: 18)),
                Text(
                    widget.orderModel!.deliveryCharge == null ||
                            widget.orderModel!.deliveryCharge == 0
                        ? 'Price not available'
                        : getAmount(
                            widget.orderModel!.deliveryCharge!,
                          ),
                    style: boldTextStyle(size: 22)),
              ],
            ).paddingOnly(left: 16, right: 16),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appStore.translate('total'),
                    style: primaryTextStyle(size: 18)),
                Text(
                    widget.orderModel!.totalAmount == null &&
                                widget.orderModel!.deliveryCharge == null ||
                            widget.orderModel!.totalAmount == 0 &&
                                widget.orderModel!.deliveryCharge == 0
                        ? 'Price not available'
                        : getAmount(
                            widget.orderModel!.deliveryCharge! +
                                widget.orderModel!.totalAmount!,
                          ),
                    style: boldTextStyle(size: 22)),
              ],
            ).paddingOnly(left: 16, right: 16),
            Observer(
                builder: (_) => Loader().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
