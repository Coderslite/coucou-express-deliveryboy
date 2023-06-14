import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/screen/DashboardScreen.dart';
import 'package:food_delivery/screen/LoginScreen.dart';
import 'package:food_delivery/screen/WalkThroughScreen.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(Duration(seconds: 2));

    if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
      WalkThroughScreen().launch(context, isNewTask: true);
    } else if (getBoolAsync(IS_LOGGED_IN)) {
      DashboardScreen().launch(context, isNewTask: true);
    } else {
      LoginScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appStore.setAppLocalization(context);
    return Scaffold(
      backgroundColor: appStore.isDarkMode ? scaffoldColorDark : white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/app_logo.png', height: 120),
          16.height,
          Text(mAppName, style: boldTextStyle(size: 20, color: primaryColor)),
        ],
      ).center(),
    );
  }
}
