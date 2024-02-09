// ignore_for_file: deprecated_member_use

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../model/OrderModel.dart';
import '../model/RestaurantsModel.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import 'NotePad.dart';

class OrderBottomDetail extends StatefulWidget {
  final OrderModel oderData;
  final RestaurantsModel data;
  final bool validRestaurant;
  const OrderBottomDetail(
      {super.key,
      required this.oderData,
      required this.data,
      required this.validRestaurant});

  @override
  State<OrderBottomDetail> createState() => _OrderBottomDetailState();
}

class _OrderBottomDetailState extends State<OrderBottomDetail> {
  bool isPlaying = false;
  bool isPaused = true;
  Duration totalDuration = Duration();
  Duration currentPosition = Duration();

  AudioPlayer audioPlayer = AudioPlayer();

  void playAudio(String audioUrl) async {
    await audioPlayer.play(UrlSource('$audioUrl')).then((value) async {
      trackProgress();
      setState(() {
        isPlaying = true;
      });
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.oderData.orderType == 'VoiceOrder'
                      ? Icon(
                          Icons.record_voice_over,
                          size: 40,
                        )
                      : commonCachedNetworkImage(widget.data.photoUrl,
                              width: 60, fit: BoxFit.cover)
                          .cornerRadiusWithClipRRect(defaultRadius),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: primaryTextStyle(size: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: widget.oderData.restaurantName == null ||
                                        widget.oderData.restaurantName == ''
                                    ? widget.oderData.orderType == 'VoiceOrder'
                                        ? 'Voice Order'
                                        : 'Yonnima Order'
                                    : '${widget.oderData.restaurantName} ',
                                style: boldTextStyle(size: 20)),
                            widget.validRestaurant == false &&
                                    widget.oderData.restaurantName != null &&
                                    widget.oderData.restaurantName != ''
                                ? TextSpan(
                                    text: '(Suggested Restaurant)',
                                    style: secondaryTextStyle(size: 12))
                                : TextSpan(),
                          ],
                        ),
                      ),
                      Text(
                        "",
                        style: primaryTextStyle(),
                      )
                    ],
                  ).expand(),
                ],
              ).paddingAll(8),
              widget.validRestaurant &&
                      widget.data.restaurantContact != null &&
                      widget.data.restaurantContact != ''
                  ? Row(
                      children: [
                        Icon(Icons.call, color: blueButtonColor).onTap(() {
                          launch('tel://${widget.data.restaurantContact}');
                        }),
                        8.width,
                        // Text(data.restaurantContact,
                        //         style: primaryTextStyle(size: 15))
                        //     .onTap(() {
                        //   launch('tel://${data.restaurantContact}');
                        // }),
                      ],
                    )
                  : Container(),
              widget.validRestaurant &&
                      widget.data.restaurantContact != null &&
                      widget.data.restaurantContact != ''
                  ? Row(
                      children: [
                        Icon(Icons.home, color: blueButtonColor),
                        8.width,
                        Text('${widget.data.restaurantAddress}',
                                style: secondaryTextStyle(size: 14),
                                maxLines: 2)
                            .expand(),
                      ],
                    )
                  : Container(),
              Divider(
                thickness: 2,
                color: context.dividerColor,
              ),
              FutureBuilder(
                  future:
                      userService.getUserById(userId: widget.oderData.userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    } else if (snapshot.hasData) {
                      var userData = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User Information",
                            style: boldTextStyle(),
                          ),
                          15.height,
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: blueButtonColor,
                              ),
                              10.width,
                              Text(userData!.name!,
                                      style: primaryTextStyle(size: 15))
                                  .onTap(() {
                                launch('tel://${userData.number}');
                              }),
                            ],
                          ),
                          5.height,
                          Row(
                            children: [
                              Icon(
                                Icons.call,
                                color: blueButtonColor,
                              ),
                              10.width,
                              Text(userData.number!,
                                      style: primaryTextStyle(size: 15))
                                  .onTap(() {
                                launch('tel://${userData.number}');
                              }),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator().center();
                    }
                  }),
              15.height,
              Text('Order Items', style: boldTextStyle())
                  .paddingOnly(left: 8, right: 8),
              15.height,
              widget.oderData.orderType == 'VoiceOrder'
                  ? Row(
                      children: [
                        InkWell(
                          onTap: () {
                            totalDuration == Duration()
                                ? playAudio(widget.oderData.orderUrl!)
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
                            ? Text(
                                "Play Audio",
                                style: primaryTextStyle(),
                              ).center()
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
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.oderData.orderItems!.length,
                itemBuilder: (_, index) {
                  OrderItems data = widget.oderData.orderItems![index];
                  return Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: boxDecorationWithShadow(
                        borderRadius: radius(),
                        backgroundColor: context.cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            commonCachedNetworkImage(
                              data.image,
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            ).cornerRadiusWithClipRRect(25),
                            8.width,
                            Text('${data.itemName}', style: boldTextStyle())
                                .expand(),
                            Text(
                                data.itemPrice == null
                                    ? 'Price not available x ${data.qty}'
                                    : '${getAmount(data.itemPrice!)} x ${data.qty}',
                                style: primaryTextStyle())
                          ],
                        ),
                        data.isSuggestedPrice.toString() == 'true'
                            ? Text(
                                "This is a suggested price by customer",
                                style: primaryTextStyle(
                                  color: orangeRed,
                                  size: 12,
                                ),
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.restaurantName.toString(),
                              style: boldTextStyle(),
                            ),
                            Text(
                              "(${data.restaurantLocation.toString()})",
                              style: primaryTextStyle(
                                color: mediumSeaGreen,
                                size: 10,
                              ),
                            ),
                          ],
                        ).visible(data.restaurantName != null &&
                            data.restaurantName != ''),
                        Text(
                          data.restaurantAddress.toString(),
                          style: primaryTextStyle(size: 12),
                        ).visible(data.restaurantLocation == 'Around UCAD')
                      ],
                    ),
                  );
                },
              ),
              8.height,
              Text(
                "Other Information",
                style: boldTextStyle(),
              ),
              Text(
                widget.oderData.otherInformation.validate(),
                style: primaryTextStyle(),
              ),
              10.height,
              widget.oderData.orderType == 'VoiceOrder'
                  ? Container()
                  : Container(
                      decoration: boxDecorationWithShadow(
                          borderRadius: radius(),
                          backgroundColor: appStore.isDarkMode
                              ? context.cardColor
                              : primaryColor),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(appStore.translate('total'),
                              style: boldTextStyle(color: white)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  widget.oderData.totalAmount == null ||
                                          widget.oderData.totalAmount == 0
                                      ? 'Price not available'
                                      : getAmount(widget.oderData.totalAmount!),
                                  style: secondaryTextStyle(color: white)),
                              4.height,
                              // Text(appStore.translate('delivery_charges'),
                              //     style: secondaryTextStyle(
                              //         size: 10, color: white)),
                            ],
                          ),
                        ],
                      )),
            ],
          ),
        ],
      ).paddingAll(8),
    );
  }
}
