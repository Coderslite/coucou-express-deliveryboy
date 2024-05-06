import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/components/StartDelivery.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/screen/track_order/SelectOrder.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class MessageModel {
  String? message;
  String? type;
  bool? isMe;
  MessageModel({
    this.message,
    this.type,
    this.isMe,
  });
}

class OrderChatScreen extends StatefulWidget {
  final OrderModel order;
  const OrderChatScreen({super.key, required this.order});

  @override
  State<OrderChatScreen> createState() => _OrderChatScreenState();
}

class _OrderChatScreenState extends State<OrderChatScreen> {
  PlayerController controller = PlayerController();
  List<MessageModel> messages = [
    MessageModel(type: "Text", message: "How are you doing", isMe: true),
    MessageModel(
      type: "Audio",
      isMe: false,
    ),
    MessageModel(type: "Image", isMe: false),
    MessageModel(type: "Text", message: "That is the file", isMe: true),
  ];

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Card(
                  color: context.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 30,
                            child: Image.asset(
                              "images/profile.png",
                              fit: BoxFit.cover,
                            )),
                        5.width,
                        Text(
                          "Ossai Abraham",
                          style: primaryTextStyle(
                            size: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  color: context.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 25,
                      child: Image.asset(
                        "images/edit.png",
                        fit: BoxFit.cover,
                        color: context.iconColor,
                      ),
                    ),
                  ),
                ).onTap(() {
                  SelectOrderScreen(
                    order: widget.order,
                  ).launch(context);
                }),
              ],
            ),
            10.height,
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  return message.type == 'Audio'
                      ? BubbleNormalAudio(
                          isSender: message.isMe.validate(),
                          delivered: true,
                          seen: true,
                          onSeekChanged: (s) {},
                          onPlayPauseButtonClick: () {})
                      : message.type == 'Image'
                          ? BubbleNormalImage(
                              id: index.toString(), image: Container())
                          : BubbleNormal(text: message.message.validate());
                },
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Card(
                  color: context.cardColor,
                  child: AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    decoration: InputDecoration(
                      hintText: "Type message ...",
                      hintStyle: secondaryTextStyle(size: 12),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(
                              "images/mic.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          10.width,
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              "images/image.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          10.width,
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(
                              "images/send.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          10.width,
                        ],
                      ),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )),
            )
          ]),
        ),
      ),
    );
  }
}
