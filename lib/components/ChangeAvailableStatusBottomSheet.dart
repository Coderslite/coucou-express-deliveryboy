import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangeAvailableStatusBottomSheet extends StatefulWidget {
  @override
  ChangeAvailableStatusBottomSheetState createState() => ChangeAvailableStatusBottomSheetState();
}

class ChangeAvailableStatusBottomSheetState extends State<ChangeAvailableStatusBottomSheet> {
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
    return Container(
      height: context.height() * 0.5,
      child: Stack(
        children: [
          SettingSection(
            headingDecoration: BoxDecoration(color: context.cardColor),
            title: Text(appStore.translate('availability_status'), style: boldTextStyle(size: 24)),
            subTitle: Text(appStore.translate('set_your_current_availability_status'), style: secondaryTextStyle()),
            items: [
              SettingItemWidget(
                title: appStore.translate('available'),
                titleTextStyle: boldTextStyle(color: primaryColor),
                subTitle: appStore.translate('you_will_receive_new_order_notification'),
                decoration: BoxDecoration(borderRadius: radius()),
                leading: Icon(Icons.check, color: primaryColor),
                onTap: () async {
                  appStore.setLoading(true);
                  await userService.updateDocument(getStringAsync(USER_ID), {UserKey.availabilityStatus: true}).then((value) async {
                    await setValue(AVAILABLE, true);
                    finish(context);
                  }).catchError((error) {
                    toast(error.toString());
                  });

                  appStore.setLoading(false);
                },
              ),
              SettingItemWidget(
                title: appStore.translate('not_available'),
                titleTextStyle: boldTextStyle(color: colorPrimary),
                subTitle: appStore.translate('you_will_not_receive_new_orders'),
                decoration: BoxDecoration(borderRadius: radius()),
                leading: Icon(Icons.close, color: colorPrimary),
                onTap: () async {
                  appStore.setLoading(true);
                  await userService.updateDocument(getStringAsync(USER_ID), {UserKey.availabilityStatus: false}).then((value) async {
                    await setValue(AVAILABLE, false);
                    finish(context);
                  }).catchError((error) {
                    toast(error.toString());
                  });

                  appStore.setLoading(false);
                },
              ),
            ],
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
