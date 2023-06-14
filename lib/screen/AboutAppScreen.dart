import 'package:flutter/material.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../main.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  AboutAppScreenState createState() => AboutAppScreenState();
}

class AboutAppScreenState extends State<AboutAppScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (appStore.isDarkMode) {
      setStatusBarColor(scaffoldColorDark);
    } else {
      setStatusBarColor(Colors.white);
    }
  }

  @override
  void dispose() {
    if (appStore.isDarkMode) {
      setStatusBarColor(scaffoldColorDark);
    } else {
      setStatusBarColor(Colors.white);
    }
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(appStore.translate('about')),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mAppName, style: primaryTextStyle(size: 30)),
              16.height,
              Container(
                decoration: BoxDecoration(color: primaryColor, borderRadius: radius(4)),
                height: 4,
                width: 100,
              ),
              16.height,
              Text(appStore.translate('version'), style: secondaryTextStyle()),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return Text('${snap.data!.version.validate()}', style: primaryTextStyle());
                  }
                  return SizedBox();
                },
              ),
              16.height,
              Text('Meet Mighty', style: primaryTextStyle()),
              16.height,
              Text(
                mAppInfo,
                style: primaryTextStyle(size: 14),
                textAlign: TextAlign.justify,
              ),
              16.height,
              AppButton(
                color: appStore.isDarkMode ? scaffoldSecondaryDark : primaryColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.contact_support_outlined, color: Colors.white),
                    8.width,
                    Text(appStore.translate('contact_us'), style: boldTextStyle(color: white)),
                  ],
                ),
                onTap: () {
                  launchUrl('mailto:${getStringAsync(CONTACT_PREF)}');
                },
              ),
              16.height,
              AppButton(
                color: appStore.isDarkMode ? scaffoldSecondaryDark : primaryColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('images/purchase.png', height: 24, color: white),
                    8.width,
                    Text(appStore.translate('purchase'), style: boldTextStyle(color: white)),
                  ],
                ),
                onTap: () {
                  launchUrl(codeCanyonURL);
                },
              ).visible(codeCanyonURL.isNotEmpty),
            ],
          ),
        ),
      ),
    );
  }
}
