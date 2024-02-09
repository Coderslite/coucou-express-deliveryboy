import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/model/RestaurantsModel.dart';
import 'package:nb_utils/nb_utils.dart';

import 'OrderBottomDetails.dart';

class RestaurantInfoBottomSheet extends StatefulWidget {
  final OrderModel? oderData;

  RestaurantInfoBottomSheet(this.oderData);

  @override
  RestaurantInfoBottomSheetState createState() =>
      RestaurantInfoBottomSheetState();
}

class RestaurantInfoBottomSheetState extends State<RestaurantInfoBottomSheet> {
  @override
  void initState() {
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
    return widget.oderData!.restaurantId == null ||
            widget.oderData!.restaurantId == ''
        ? OrderBottomDetail(
            oderData: widget.oderData!,
            data: RestaurantsModel(),
            validRestaurant: false,
          )
        : FutureBuilder<RestaurantsModel>(
            future: restaurantsServices.getRestaurantById(
                restaurantId: widget.oderData!.restaurantId),
            builder: (_, snap) {
              RestaurantsModel? data = snap.data;

              if (snap.hasData) {
                return OrderBottomDetail(
                  oderData: widget.oderData!,
                  data: data!,
                  validRestaurant: true,
                );
              } else {
                return snapWidgetHelper(snap);
              }
            },
          );
  }
}
