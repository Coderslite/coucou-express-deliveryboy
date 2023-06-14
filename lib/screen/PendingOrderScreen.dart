import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery/components/PendingOrderItemWidget.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:paginate_firestore/widgets/empty_display.dart';

import '../main.dart';
import 'TrackingScreen.dart';

class PendingOrderScreen extends StatefulWidget {
  static String tag = '/OrderScreen';

  @override
  PendingOrderScreenState createState() => PendingOrderScreenState();
}

class PendingOrderScreenState extends State<PendingOrderScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldColorDark : white,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appStore.setAppLocalization(context);
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(appStore.translate('new_orders'), showBack: false),
        body: getBoolAsync(AVAILABLE, defaultValue: true)
            ? PaginateFirestore(
                itemBuilder: (BuildContext context, items, index) {
                  var order = items[index].data() as Map<String, dynamic>;
                  return order['orderStatus'] == ORDER_STATUS_RECEIVED &&
                          order['deliveryBoyId'] == null
                      ? PendingOrderItemWidget(
                          orderData: OrderModel.fromJson(order),
                          onAccept: () {
                            setState(() {
                              orderServices.updateDocument(items[index].id, {
                                OrderKey.deliveryBoyId: getStringAsync(USER_ID),
                              });
                            });
                          },
                        )
                      : Container();
                },
                itemBuilderType: PaginateBuilderType.listView,
                query: orderServices.pendingOrderQuery(),
                isLive: true,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemsPerPage: DocLimit,
                bottomLoader: Loader(),
                initialLoader: Loader(),
                onEmpty:EmptyDisplay(),
                onError: (e) =>
                    Text(e.toString(), style: primaryTextStyle()).center(),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/Not_available.png',
                          width: 150,
                          height: 150,
                        ).center(),
                        32.height,
                        Text(appStore.translate('your_status_is_not_available'),
                            style: primaryTextStyle(),
                            textAlign: TextAlign.center),
                        16.height,
                        AppButton(
                          text: appStore.translate('set_to_Available'),
                          textStyle: boldTextStyle(),
                          onTap: () async {
                            showConfirmDialog(
                                    context,
                                    appStore.translate(
                                        'are_you_sure_change_want_your_status'),
                                    positiveText: appStore.translate('yes'),
                                    negativeText: appStore.translate('no'))
                                .then((value) async {
                              if (value ?? false) {
                                appStore.setLoading(true);
                                await userService.updateDocument(
                                    getStringAsync(USER_ID), {
                                  UserKey.availabilityStatus: true
                                }).then((value) async {
                                  await setValue(AVAILABLE, true);
                                  setState(() {});
                                }).catchError((error) {
                                  toast(error.toString());
                                });
                              }
                              appStore.setLoading(false);
                            });
                          },
                        ).center(),
                      ],
                    ),
                  ),
                  Observer(
                      builder: (_) => Loader().visible(appStore.isLoading)),
                ],
              ).center(),
      ),
    );
  }
}
