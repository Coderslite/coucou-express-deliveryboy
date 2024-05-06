import 'package:flutter/material.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ArrivedAtBuyFrom extends StatefulWidget {
  const ArrivedAtBuyFrom({super.key});

  @override
  State<ArrivedAtBuyFrom> createState() => _ArrivedAtBuyFromState();
}

class _ArrivedAtBuyFromState extends State<ArrivedAtBuyFrom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Please enter the prices for the items below and upload the payment receipt as a proof of payment.",
          style: primaryTextStyle(size: 12),
        ),
        10.height,
        Expanded(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(15.0),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Item ${index + 1}",
                          style: boldTextStyle(
                            size: 16,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: Material(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                "Add Price",
                                style: primaryTextStyle(color: white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                })),
        10.height,
        Container(
          width: double.infinity,
          height: 60,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: primaryColor,
            ),
          ),
          child: Text(
            "Add a photo of payment Receipt (Optional)",
            style: boldTextStyle(
              size: 14,
            ),
          ),
        ).onTap(() {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.height,
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Divider(
                          thickness: 2,
                        ),
                      ).center(),
                      20.height,
                      Text(
                        "Add Photo",
                        style: boldTextStyle(
                          size: 16,
                          color: primaryColor,
                        ),
                      ),
                      10.height,
                      Divider(),
                      10.height,
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              "images/camera.png",
                              fit: BoxFit.cover,
                              color: context.iconColor.withOpacity(0.7),
                            ),
                          ),
                          10.width,
                          Text(
                            "Take a photo",
                            style: boldTextStyle(
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                      10.height,
                      Divider(),
                      10.height,
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              "images/image.png",
                              fit: BoxFit.cover,
                              color: context.iconColor.withOpacity(0.7),
                            ),
                          ),
                          10.width,
                          Text(
                            "Choose from library",
                            style: boldTextStyle(
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                      20.height,
                    ],
                  ),
                );
              });
        }),
        20.height,
      ],
    );
  }
}
