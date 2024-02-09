import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/screen/LoginScreen.dart';
import 'package:food_delivery/screen/OrderHistoryScreen.dart';
import 'package:food_delivery/screen/PendingOrderScreen.dart';
import 'package:food_delivery/screen/ProfileScreen.dart';
import 'package:food_delivery/screen/ReviewScreen.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:upgrader/upgrader.dart';

import '../services/GetFixedDeliveryCharge.dart';
import '../services/GetkiloDeliveryCharge.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>
    with AfterLayoutMixin<DashboardScreen> {
  int mCurrent = 0;

  List<Widget> page = [
    PendingOrderScreen(),
    OrderHistoryScreen(),
    ReviewScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    handleGetFixCharge();
    super.initState();
    init();
    updateUserProfile();
  }

  Future<void> init() async {
    await appSettingService.setAppSettings();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    appStore.setAppLocalization(context);
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      if (!appStore.isLoggedIn) {
        LoginScreen().launch(context, isNewTask: true);
      } else {
        //
      }
    });
  }

  void updateUserProfile() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      userService.updateDocument(getStringAsync(USER_ID), {
        UserKey.latitude: position.latitude,
        UserKey.longitude: position.longitude,
        UserKey.oneSignalPlayerId: getStringAsync(PLAYER_ID),
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  handleGetFixCharge() async {
    var fee = await getFixedDeliveryFee();
    var fee2 = await getKiloDeliveryFee();
    print("delivery fee ${fee.amount}");
    appStore.setConstantDeliveryCharge(fee.amount!.toDouble());
    appStore.setKmDeliveryCharge(fee2.amount!.toDouble());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appStore.setAppLocalization(context);
    return RefreshIndicator(
      backgroundColor: white,
      color: primaryColor,
      onRefresh: () async {
        /// If you want to update app setting every time when you refresh home page
        /// Uncomment the below line
        await appSettingService.setAppSettings();
        setState(() {});
        await 2.seconds.delay;
      },
      child: UpgradeAlert(
        upgrader: Upgrader(
          canDismissDialog: false,
          showIgnore: false,
          showLater: false,
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
          durationUntilAlertAgain: const Duration(minutes: 1),
        ),
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              mCurrent = value;
              setState(() {});
            },
            currentIndex: mCurrent,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('images/NewOrder.png',
                    color: Colors.grey, width: 26, height: 26),
                activeIcon: Image.asset('images/NewOrder.png',
                    color: appStore.isDarkMode ? blueButtonColor : colorPrimary,
                    width: 26,
                    height: 26),
                label: appStore.translate('new_orders'),
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/OrderHistory.png',
                    color: Colors.grey, width: 26, height: 26),
                activeIcon: Image.asset('images/OrderHistory.png',
                    color: appStore.isDarkMode ? blueButtonColor : colorPrimary,
                    width: 26,
                    height: 26),
                label: appStore.translate('order_history'),
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/review.png',
                    color: Colors.grey, width: 26, height: 26),
                activeIcon: Image.asset('images/review.png',
                    color: appStore.isDarkMode ? blueButtonColor : colorPrimary,
                    width: 26,
                    height: 26),
                label: appStore.translate('review'),
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/profile.png',
                    color: Colors.grey, width: 26, height: 26),
                activeIcon: Image.asset('images/profile.png',
                    color: appStore.isDarkMode ? blueButtonColor : colorPrimary,
                    width: 26,
                    height: 26),
                label: appStore.translate('profile'),
              ),
            ],
          ),
          body: page[mCurrent],
        ),
      ),
    );
  }
}
